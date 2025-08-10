
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts


Rectangle {
    property string cpu: "k10temp-pci-00c3"
    property int pollingRate: 1000

    color: palette.active.base
    
    implicitWidth: layout.width + (textPadding * 2)
    Layout.fillHeight: true
    
    radius: borderRadius
    

    RowLayout {
        id: layout

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        
        anchors.leftMargin: textPadding

        IconImage {
            source: Quickshell.iconPath("am-cpu-symbolic")
            implicitSize: 20
        }
        
        Text {
            id: cpuTempText
            text: ""
            
            color: palette.active.text
        }
        
        Process {
            id: getTemp
            
            running: false
            command: ["sensors", "-j"]
            
            stdout: StdioCollector {
                onStreamFinished: {
                    const cpuTemp = JSON.parse(this.text)[cpu]["Tctl"]["temp1_input"]
                    
                    var temp = String(Math.round(cpuTemp))
                    cpuTempText.text = temp + "℃"
                }
            }
        }
        
        Timer {
            running: true
            repeat: true
            interval: pollingRate
            
            onTriggered: {
                getTemp.running = true
            } 
        }
    }
}