
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

import QtQuick
import QtQuick.Layouts

import QtQml.Models



Scope {
    // if dragged to left side with half of width of notification bar, deletes the notification
    property var dragDeleteRatio: 0.5


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
        

        ColumnLayout {
            anchors.fill: parent

            spacing: windowGap

            Rectangle {
                id: titleBg
                
                Layout.alignment: Text.AlignTop

                Layout.fillWidth: true
                implicitHeight: titleLayout.height + textPadding
                
                color: palette.active.window
                
                radius: borderRadius

                
                RowLayout {
                    id: titleLayout

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    Text {
                        Layout.topMargin: textPadding
                        Layout.leftMargin: textPadding

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

                        Layout.alignment: Text.AlignVCenter
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
                                for (var i = 0; i < notifs; i++) {
                                   notifServer.trackedNotifications.values[0].dismiss()
                                }
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
            }
            
            Rectangle {
                Layout.alignment: Text.AlignTop
                
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                color: palette.active.window

                radius: borderRadius


                ListView {
                    id: view
                    
                    anchors {
                        fill: parent
                        topMargin: textPadding
                        leftMargin: textPadding
                    }

                    spacing: textPadding
                    
                    model: notifServer.trackedNotifications
                    
                    clip: true

                    delegate: Rectangle {
                        id: holder

                        required property int index
                        required property var modelData

                        property string icon: modelData.appIcon
                        property string summary: modelData.summary
                        property string body: modelData.body

                        // Status
                        property bool expanded: false


                        function toggleExpand() {
                            expanded = !expanded
                            
                            summaryText.maximumLineCount = expanded ? Number.MAX_SAFE_INTEGER : 1
                            bodyText.maximumLineCount = expanded ? Number.MAX_SAFE_INTEGER : 1
                        }
                        
                        implicitWidth: window.width - textPadding * 2
                        implicitHeight: verLayout.height + textPadding * 2
                                    
                        radius: borderRadius

                        color: palette.active.light
                        
                        Behavior on x {
                            NumberAnimation {
                                easing.type: Easing.InOutQuad
                                duration: animateTime
                            }
                        }

                        // Placing order matters...
                        MouseArea {
                            id: dragZone
                            
                            anchors.fill: parent
                            
                            drag {
                                target: holder
                                axis: Drag.XAxis
                                
                                maximumX: 0
                                minimumX: -holder.width
                            }
                            
                            onPositionChanged: {
                                if (holder.x !== 0) {
                                    var percentage = holder.x / (-holder.width / (1 / dragDeleteRatio))
                                    delIndicator.opacity = percentage
                                    delIcon.anchors.rightMargin = holder.x

                                    delIcon.visible = (percentage >= 1)
                                } else {
                                    delIndicator.opacity = 0
                                    delIcon.visible = false
                                }
                            }

                            onReleased: {
                                if (holder.x <= -holder.width / (1 / dragDeleteRatio)) {
                                    holder.x = -holder.width - textPadding
                                    animationTimer.running = true
                                } else {
                                    holder.x = 0
                                    delIndicator.opacity = 0
                                }
                            }
                        }
                        
                        Timer {
                            id: animationTimer
                            running: false
                            interval: animateTime
                            
                            onTriggered: {
                                modelData?.dismiss()
                                notifCount -= 1
                            }
                        }

                        RowLayout {
                            id: horLayout
                            
                            anchors {
                                fill: parent

                                leftMargin: textPadding
                                rightMargin: textPadding
                            }
                                        
                            IconImage {
                                id: appIcon
                                            
                                Layout.alignment: Text.AlignTop
                                Layout.topMargin: textPadding
                                            
                                implicitSize: 30
                                source: Quickshell.iconPath(icon, true) || icon
                                            
                                visible: source != ""
                            }
                                        
                            ColumnLayout {
                                id: verLayout

                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                            
                                RowLayout {

                                    Text {
                                        id: summaryText

                                        Layout.fillWidth: true

                                        text: summary
                                        color: palette.active.text
                                        wrapMode: Text.WordWrap
                                                    
                                        maximumLineCount: 1

                                        visible: text != ""
                                    }
                                    
                                    Rectangle {
                                        id: expandBg

                                        implicitWidth: expandIcon.width
                                        implicitHeight: expandIcon.width
                                        
                                        radius: borderRadius
                                        
                                        color: palette.active.button

                                        IconImage {
                                            id: expandIcon
                                            
                                            implicitSize: 20
                                            source: Quickshell.iconPath(expanded ? "collapse" : "expand", true)
                                        }
                                        
                                        MouseArea {
                                            anchors.fill: parent
                                            
                                            hoverEnabled: true

                                            onClicked: {
                                                toggleExpand()
                                            }
                                            
                                            onEntered: {
                                                expandBg.color = palette.active.accent
                                            }

                                            onExited : {
                                                expandBg.color = palette.active.button
                                            }
                                        }
                                    }
                                }

                                Text {
                                    id: bodyText

                                    Layout.fillWidth: true

                                    text: body
                                    color: palette.active.text
                                    
                                    maximumLineCount: 1
                                    wrapMode: Text.WordWrap
                                                
                                    visible: text != ""
                                }
                            }
                        }
                        
                        Rectangle {
                            id: delIndicator
                            
                            z: -1
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom

                            anchors.left: parent.left

                            topLeftRadius: borderRadius
                            bottomLeftRadius: borderRadius

                            implicitWidth: holder.width * 2
                            
                            color: "salmon"
                            
                            opacity: 0
                        }

                        IconImage {
                            id: delIcon
                            
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            implicitSize: 20
                            source: Quickshell.iconPath("delete", true)
                            
                            visible: false
                        }
                        
                        Component.onCompleted: {
                            // if the body text is truncated, show the expand button
                            expandBg.visible = bodyText.truncated
                        }
                    }
                }
            }

        }
    }
}