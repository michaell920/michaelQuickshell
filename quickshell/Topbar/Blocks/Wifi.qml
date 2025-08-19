
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts


Rectangle {
    property int pollingRate: 1000

    property bool connected: false


    color: palette.active.window

    Layout.preferredWidth: layout.width + (textPadding * 2)
    Layout.fillHeight: true

    radius: borderRadius
    

    RowLayout {
        id: layout
        
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        
        anchors.leftMargin: textPadding
        
        IconImage {
            id: wifiIcon
            
            source: ""
            implicitSize: 20
        }
        
        Text {
            id: wifiText
            text: ""
            
            color: palette.active.text
            
            Component.onCompleted: {
                getWifiName.running = true
            }
        }
        
        Process {
            id: getWifiSignal

            running: true
            command: ["nmcli", "-f", "SIGNAL,ACTIVE,SSID,DEVICE", "dev", "wifi", "list"]

            stdout: SplitParser {
                onRead: (data) => {
                    const textStr = data.split(/\s{1,}/)

                    if (textStr[1] == "yes") {
                        var roundUp = Math.floor(textStr[0] / 20) * 20
                        wifiIcon.source = Quickshell.iconPath("network-wireless-" + roundUp)
                        wifiText.text = textStr[2]
                    }
                }
            }
        }
        
        Process {
            id: checkIfConnected
            running: true
            command: ["nmcli", "device", "monitor"]
            
            stdout: SplitParser {
                onRead: (data) => {
                    const textStr = data.split(": ")
                    
                    if (textStr[0] == wifiInterface) {
                        if (textStr[1] == "connected") {
                            connected = true
                            getWifiSignal.running = true
                        } else if (textStr[1] == "disconnected") {
                            wifiIcon.source = Quickshell.iconPath("network-wireless-disconnected")
                            wifiText.text = textStr[1]
                        }
                    }
                }
            }
        }

        Timer {
            running: connected
            interval: pollingRate
            repeat: true

            onTriggered: {
                checkIfConnected.running = true
            }
        }
        
    }

}
