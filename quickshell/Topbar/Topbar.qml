
import Quickshell

import QtQuick
import QtQuick.Layouts

import "Blocks" as Blocks


Scope {

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar

            required property var modelData
            screen: modelData

            color: "Transparent"
            implicitHeight: 30

            anchors {
                top: true
                left: true
                right: true

            }
            
            margins {
                top: windowGap
                left: windowGap
                right: windowGap
                bottom: 20
            }

            Item {
                id: allblocks

                anchors.fill: parent


                RowLayout {
                    id: leftblocks

                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    
                    spacing: 5

                    Blocks.Clock {}
                    Blocks.WindowTitle {}

                }
                
                RowLayout {
                    id: centerblocks

                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    Blocks.Mpris {}
                }

                RowLayout {
                    id: rightblocks

                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    
                    spacing: 5


                    Blocks.Wifi {}
                    Blocks.CPU {}
                    Blocks.Battery {}
                    Blocks.PowerPlan {}
                    Blocks.ExternalMonitor {}
                    Blocks.Systray {}
                    Blocks.NotificationToggle {}
                }
            }
        }
    }
}

