
import Quickshell
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import QtQml.Models

import Qt5Compat.GraphicalEffects


Scope {
    
    DelegateModel {
        id: notifications
        
        model: notificationsList


        delegate: Rectangle {
            required property int index
            required property var modelData
                        
            property string icon: modelData.icon
            property string body: modelData.body
            property string summary: modelData.summary
                        
            implicitWidth: window.width - textPadding * 2
            implicitHeight: verLayout.height + textPadding * 2
                        
            radius: borderRadius

            color: palette.active.light
                        

            RowLayout {
                id: horLayout
                
                anchors {
                    fill: parent

                    leftMargin: textPadding
                    rightMargin: textPadding

                    top: parent.top                               
                    topMargin: textPadding
                }
                            
                IconImage {
                    id: appIcon
                                
                    Layout.alignment: Text.AlignTop
                                
                    implicitSize: 30
                    source: Quickshell.iconPath(icon, true) || icon
                                
                    visible: source != ""
                }
                            
                ColumnLayout {
                    id: verLayout

                    Layout.fillWidth: true
                                
                    RowLayout {
                        
                        Text {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            text: summary
                            color: palette.active.text
                                        
                            visible: text != ""
                        }
                                    
                        IconImage {
                            Layout.alignment: Text.AlignTop


                            implicitSize: 20
                            source: Quickshell.iconPath("window-close", true)
                            
                        }
                                
                    }

                    Text {
                        Layout.fillWidth: true

                        text: body
                        color: palette.active.text
                        
                        wrapMode: Text.WordWrap
                                    
                        visible: text != ""
                    }
                }
            }
        }
    }

    PanelWindow {
        id: window
        
        anchors {
            top: true
            bottom: true
            right: true   
        }
        
        margins {
            right: windowGap
            bottom: windowGap
        }

        implicitWidth: 300
        
        color: "Transparent"
        
        exclusionMode: ExclusionMode.Normal
        

        Rectangle {
            anchors.fill: parent   
            
            color: palette.active.base
            radius: borderRadius
            

            ColumnLayout {
                anchors.fill: parent
                
                anchors.topMargin: textPadding
                anchors.leftMargin: textPadding
                
                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Text.AlignTop

                    Text {
                        Layout.fillWidth: true

                        text: "Notifications"
                        
                        color: palette.active.text
                        
                        font.bold: true

                        Component.onCompleted: {
                            // Do this to avoid binding loop
                            font.pointSize = font.pointSize * 1.5
                        }
                    }
                    
                    Rectangle {
                        id: clearBg

                        Layout.rightMargin: textPadding
                        
                        implicitWidth: clearIcon.width
                        implicitHeight: clearIcon.height
                        
                        color: palette.active.button
                        
                        radius: borderRadius

                        Behavior on color {
                            ColorAnimation {
                                duration: animateTime
                            }
                        }

                        IconImage {
                            id: clearIcon
                            implicitSize: 25

                            source: Quickshell.iconPath("edit-clear-all")
                            
                        }

                        MouseArea {
                            anchors.fill: parent

                            hoverEnabled: true
                            
                            onClicked: {
                                for (var i = 0; i < notificationsList.count; i++) {
                                    var entry = notificationsList.get(i).notif
                                    entry?.dismiss()
                                }
                                notificationsList.clear()
                                updateCount()
                            }
                                
                            onEntered: {
                                clearBg.color = palette.active.accent
                            }
                                
                            onExited: {
                                clearBg.color = palette.active.button
                            }
                        }
                    }
                }
                
                ListView {
                    id: view
                    
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    spacing: textPadding
                    
                    model: notifications
                }
            }
        }
        
    }
}