
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

Rectangle {
    property var wheelThresholdTime: 200
    
    // I had to set variable on run time cause binding does not work
    // Hope someone come up with a smarter idea
    // The second one is the actual value
    property var step: ["+", "5"]
    property var baseCmd: ["ddcutil", "setvcp", "10" ,"--bus", "3"]

    color: palette.active.window
    
    implicitWidth: layout.width + (textPadding * 2)
    Layout.fillHeight: true
    
    radius: borderRadius
    
    RowLayout {
        id: layout

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        
        anchors.leftMargin: textPadding
        

        IconImage {
            implicitSize: 20
            source: "image://icon/high-brightness"
        }

        Text {
            id: brightness
            
            text: "100%"
            
            color: palette.active.text
        }
    }
    
    MouseArea {
        anchors.fill: parent

        onWheel: (event) => {
            if (!stopRegister.running) {
                stopRegister.running = true
                
                console.log(event.angleDelta)

                if (event.angleDelta.y > 0)
                    step[0] = "+"
                else
                    step[0] = "-"

                setBrightness.exec({
                    command: baseCmd.concat(step)
                })
            }
        }
    }
    
    Process {
        id: getBrightness 

        running: true
        command: ["ddcutil", "getvcp", "10", "--bus", "3"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                // God save me cause i don't know how to use regex in javascript
                brightness.text = text.split(": ")[1].split("=")[1].split(",")[0].slice(3) + "%"
            }
        }
    }

    Process {
        id: setBrightness

        running: false
        
        onExited: {
            getBrightness.running = true
        }
    }
    
    Timer {
        id: stopRegister
        running: false
        interval: wheelThresholdTime
    }
}