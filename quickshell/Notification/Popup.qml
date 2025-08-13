
import Quickshell
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import QtQml.Models

import Qt5Compat.GraphicalEffects


Scope {

    property int showTime: 5000

    DelegateModel {
        id: popupNotifications 

        model: notificationsList
        
        groups: DelegateModelGroup {
            id: popupEntries
            name: "popups"
            includeByDefault: true
        }
        
        filterOnGroup: "popups"
        
        delegate: Rectangle {
            required property var index

            required property var icon
            required property var summary
            required property var body
            
            required property var notif
            
            width: 300
            implicitHeight: verLayout.height + textPadding * 2

            radius: borderRadius
            
            color: palette.active.base
            
            
            RowLayout {
                id: horLayout
                
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right

                    topMargin: textPadding
                    leftMargin: textPadding
                    rightMargin: textPadding
                }
                
                IconImage {
                    id: popupIcon   
                    
                    Layout.alignment: Text.AlignTop
                    
                    implicitSize: 30
                    source: Quickshell.iconPath(icon, true) || icon
                    
                    visible: source != ""
                }
                
                ColumnLayout {
                    id: verLayout
                    
                    Layout.fillWidth: true
                    

                    Text {
                        text: summary
                        color: palette.active.text
                        
                        Layout.fillHeight: true
                        
                        visible: text != ""
                    }
                    
                    Text {
                        text: body
                        color: palette.active.text

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        
                        wrapMode: Text.WordWrap
                        visible: text != ""
                    }
                }
            }
            
            MouseArea {
                anchors.fill: parent
                
                onClicked: {
                    notif?.dismiss()
                    notifCount = notificationsList.count - 1
                    notificationsList.remove(index, 1)
                }
            }
            
            Timer {
                id: closeTimer
                interval: showTime
                running: false
                
                onTriggered: {
                    popupNotifications.items.get(index).inPopups = false
                }
            }
            
            Component.onCompleted: {
                closeTimer.running = true
            }
        }

    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: root
            
            required property var modelData
            
            anchors {
                top: true
                right: true
            }
            
            margins.right: windowGap
            
            screen: modelData
            exclusionMode: ExclusionMode.Auto
            
            implicitWidth: 300
            implicitHeight: layout.height
            
            color: "Transparent"
            
            visible: popupVisible
            
            ColumnLayout {
                id: layout

                anchors.left: parent.left
                anchors.right: parent.right
                
                Repeater {
                    model: popupNotifications
                }
            }
            
        }
    }
}