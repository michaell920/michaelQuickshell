
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import QtQml.Models
import Qt5Compat.GraphicalEffects


// Bigger brain at https://martin.rpdev.net/2019/01/15/using-delegatemodel-in-qml-for-sorting-and-filtering.html

Scope {
    property int entryHeight: 30
    property int searchBarHeight: 30
    

    LazyLoader {
        id: launcherLoader
        active: false
        
        component: PanelWindow {
            id: root
            
            implicitWidth: 300
            implicitHeight: 300
            
            color: "Transparent"

            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand


            Rectangle {
                id: bg

                anchors.fill: parent
                
                color: palette.active.base
                
                radius: borderRadius
                
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: bg.width
                        height: bg.height
                        radius: borderRadius
                    }
                }
                
                DelegateModel {
                    id: entriesModel
                    model: entriesList


                    function update() {
                        var visibleArr = []

                        if (searchBar.text != "") {
                            const regex = new RegExp(searchBar.text.toLowerCase())

                            for (var i = 0; i < items.count - 1; i++) {
                                var item = items.get(i)
                                var entry = item.model
                                
                                var entryName = entry.name.toLowerCase()
                                var entryTitle = entry.title.toLowerCase()

                                if (item.inResults) {
                                    if (!entryTitle.match(regex) && !entryName.match(regex)) {
                                        item.inResults = false
                                    }
                                } else {
                                    if (entryTitle.match(regex) || entryName.match(regex)) {
                                        visibleArr.push(item)
                                    }
                                }
                            }
                        } else {
                            resultEntries.removeGroups(0, resultEntries.count - 1)
                            
                            for (var i = 0; i < items.count - 1; i++) {
                                visibleArr.push(items.get(i))
                            }
                        }
                        
                        // Sort
                        visibleArr.sort(function(a, b) {
                            return a.model.title.localeCompare(b.model.title)
                        })

                        // Sort again in the result group
                        for (var i = 0; i < visibleArr.length - 1; i++) {
                            var item = visibleArr[i]
                            item.inResults = true
                            if (item.resultsIndex !== i) {
                                resultEntries.move(item.resultsIndex, i, 1);
                            }
                        }
                    }
                    
                    groups: DelegateModelGroup {
                        id: resultEntries
                        name: "results"
                        includeByDefault: false
                    }
                    
                    filterOnGroup: "results"
                    
                    items.onChanged: update()
                    
                    
                    delegate: Rectangle {
                        id: entryHolder

                        required property string name
                        required property string title
                        required property string icon

                        required property int index
                        
                        
                        anchors.left: view.contentItem.left
                        anchors.right: view.contentItem.right

                        implicitHeight: entryHeight
                        
                        color: "Transparent"
                        
                        
                        RowLayout {
                            id: entryLayout
                            
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: textPadding

                            IconImage {
                                implicitSize: 20
                                source: Quickshell.iconPath(icon)
                            }

                            Text {
                                text: title
                                
                                color: palette.active.text

                                style: entryHolder.ListView.isCurrentItem ? Text.Outline: Text.Normal
                                styleColor: palette.active.shadow
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            
                            onClicked: {
                                view.currentIndex = index
                            }
                            
                            onDoubleClicked: {
                                launchApplication()
                            }
                        }
                    }
                }

                ListModel {
                    id: entriesList
                }

                ColumnLayout {
                    anchors.fill: parent

                    TextField {
                        id: searchBar
                        
                        z: 1

                        Layout.fillWidth: true
                        implicitHeight: searchBarHeight
                            
                        background: Rectangle { 
                            border.width: 1
                            
                            topLeftRadius: borderRadius
                            topRightRadius: borderRadius
                            
                            color: palette.active.base
                        }
                
                        Component.onCompleted: {
                            forceActiveFocus()
                        }
                        
                        Keys.onPressed: event => {
                            switch(event.key) {
                                case Qt.Key_Up: {
                                    var curIndex = view.currentIndex - 1
                                    if (curIndex < 0) {
                                        curIndex = view.count - 1
                                    }
                                    view.currentIndex = curIndex
                                    break
                                }
                                case Qt.Key_Down: {
                                    var curIndex = view.currentIndex + 1
                                    if (curIndex > view.count - 1) {
                                        curIndex = 0
                                    }
                                    view.currentIndex = curIndex
                                    break
                                }
                                case Qt.Key_Return: {
                                    launchApplication()
                                    break
                                }
                                default: {
                                    break
                                }
                            }
                        }
                        
                        Keys.onReleased: event => {
                            entriesModel.update()
                        }
                    }

                    ListView {
                        id: view
                        
                        z: 0
                        
                        Layout.fillWidth: true
                        Layout.fillHeight: true
    
                        model: entriesModel
                        
                        highlight: Rectangle { color: palette.active.accent }
                        highlightMoveDuration: 0
                    }

                    
                    Component.onCompleted: {
                        getDesktopEntries.running = true
                    }
                }

            }

            Process {
                id: getDesktopEntries 
                running: false
                command: [Quickshell.shellDir + "/scripts/findAppId"]
                
                stdout: SplitParser {
                    onRead: data => {
                        var entry = data.split(",") 

                        if (entry[3] != "true") {
                            entriesList.append({ 
                                "name": entry[0], 
                                "title": entry[1],
                                "icon": entry[2].split(" ")[0],
                            })
                        }
                    }
                }
            }
            
            function launchApplication() {
                launchApp.startDetached()
                launcherLoader.active = false
            }
            
            Process {
                id: launchApp

                running: false
                command: ["gtk-launch", view.currentItem?.name]
            }
        }
    }


    IpcHandler {
        target: "launcherLoader"

        function toggleLoader() : void { launcherLoader.active = !launcherLoader.active }
    }

}