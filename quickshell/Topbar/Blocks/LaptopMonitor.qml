
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

Rectangle {
    property var wheelThresholdTime: 200
    property var interval: 1000
    
    // I had to set variable on run time cause binding does not work
    // Hope someone come up with a smarter idea
    // The second one is the actual value
    property string step: "5%"
    property var baseCmd: ["brightnessctl", "set"]
    
    property int maxBrightness: 0

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
                var stepChar = "+"

                stopRegister.running = true
                
                if (event.angleDelta.y > 0)
                    stepChar = "+"
                else
                    stepChar = "-"

                setBrightness.exec({
                    command: baseCmd.concat(step.concat(stepChar))
                })
            }
        }
    }
    
    Process {
        id: getBrightness 

        running: true
        command: ["brightnessctl", "get"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                // God save me cause i don't know how to use regex in javascript
                var percent = Math.round(parseInt(this.text) * 100 / maxBrightness)
                brightness.text = percent + "%"
            }
        }
    }

    Process {
        id: getMaxBrightness 

        running: true
        command: ["brightnessctl", "m"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                maxBrightness = parseInt(this.text)
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
    
    Timer {
        id: loop
        running: true
        repeat: true
        interval: interval
        
        onTriggered: {
            getBrightness.running = true
        }
    }
}