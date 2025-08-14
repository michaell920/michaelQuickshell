
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
// Known issue: very slow launcher, takes 1-2 seconds to load

Scope {
    id: root 

    property int entryHeight: 30
    property int searchBarHeight: 30
    

    ListModel {
        id: entriesList
    }

    DelegateModel {
        id: entriesModel
        model: entriesList
        
        property var visibleArr: []

        function filter(text) {
            visibleArr = []

            const regex = new RegExp(text.toLowerCase())

            for (var i = 0; i < items.count; i++) {
                var item = items.get(i)
                var entry = item.model
                
                var entryName = entry.name.toLowerCase()
                var entryTitle = entry.title.toLowerCase()
                
                // If the item is in the "results" group
                if (item.inResults) {
                    // If does not match the title nor the name
                    if (!entryTitle.match(regex) && !entryName.match(regex)) {
                        item.inResults = false
                    } else {
                        visibleArr.push(item)
                    }
                } else {
                    // If the item is not in the "results" group and matches the regex
                    if (entryTitle.match(regex) || entryName.match(regex)) {
                        // Add it to the visibleArr
                        visibleArr.push(item)
                    }
                }
            }

            update()
        }
        
        function fill() {
            visibleArr = []

            // Remove all result entries
            resultEntries.removeGroups(0, resultEntries.count)
                
            // Add all available entries to the visibleArr
            for (var i = 0; i < items.count - 1; i++) {
                visibleArr.push(items.get(i))
            }

            update()
        }

        function update() {
            // Sort
            visibleArr.sort(function(a, b) {
                return a.model.title.localeCompare(b.model.title)
            })
            
            // Sort again in the result group
            for (var i = 0; i < visibleArr.length; i++) {
                var item = visibleArr[i]

                // Make things in visibleArr present in the "results" group
                item.inResults = true

                if (item.resultsIndex !== i) {
                    resultEntries.move(item.resultsIndex, i, 1)
                }
            }
        }
        
        groups: DelegateModelGroup {
            id: resultEntries
            name: "results"
            includeByDefault: false
        }
        
        filterOnGroup: "results"
        
    }

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
                
                color: palette.active.window
                
                radius: borderRadius
                
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: bg.width
                        height: bg.height
                        radius: borderRadius
                    }
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
                            
                            color: palette.active.window
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
                                case Qt.Key_Escape: {
                                    launcherLoader.active = false
                                }
                                default: {
                                    break
                                }
                            }
                        }
                        
                        Keys.onReleased: event => {
                            if (searchBar.text.trim().length != 0) {
                                entriesModel.filter(searchBar.text.trim())
                            } else {
                                entriesModel.fill()
                            }

                        }
                    }

                    ListView {
                        id: view
                        
                        z: 0
                        
                        Layout.fillWidth: true
                        Layout.fillHeight: true
    
                        model: entriesModel
                        
                        highlight: Rectangle { color: palette.active.highlight }
                        highlightMoveDuration: 0
                        

                        delegate: Rectangle {
                            id: entryHolder

                            required property string name
                            required property string title
                            required property string icon
                            required property string path


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
                                    // Inefficient script, God save us please....
                                    for (var i = 0; i < resultEntries.count - 1; i++) {
                                        var entry = resultEntries.get(i)
                                        if (entry.model.path === path) {
                                            view.currentIndex = i
                                            break
                                        }
                                    }
                                }
                                
                                onDoubleClicked: {
                                    launchApplication()
                                }
                            }
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


    Process {
        id: getDesktopEntries 
        running: false
        command: [Quickshell.shellDir + "/scripts/findAppId"]
        
        onStarted: {
            entriesList.clear()
        }

        stdout: SplitParser {
            onRead: data => {
                var entry = data.split(",") 

                if (entry[3] !== "true") {
                    entriesList.append({ 
                        "name": entry[0], 
                        "title": entry[1],
                        "icon": entry[2].split(" ")[0],
                        "path": entry[4]
                    })
                }
            }
        }

        onExited: {
            entriesModel.fill()
        }
    }


    IpcHandler {
        target: "launcherLoader"

        function toggleLoader() { 
            launcherLoader.active = !launcherLoader.active

            if (launcherLoader.active) {
                getDesktopEntries.running = false
                getDesktopEntries.running = true
            }
        }
    }

}