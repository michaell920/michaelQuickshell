
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import QtQuick
import QtQuick.Layouts


Rectangle {
    property var wheelThresholdTime: 200
    
    property PwNode defaultSink: Pipewire.defaultAudioSink
    
    color: palette.active.window
    
    implicitWidth: layout.width + textPadding * 2
    Layout.fillHeight: true
    
    radius: borderRadius
    
	PwObjectTracker { objects: [ defaultSink ] }

    RowLayout {
        id: layout
        
        anchors {
            left: parent.left
            leftMargin: textPadding
            
            verticalCenter: parent.verticalCenter
        }
        
        IconImage {
            source: {
                const vol = Math.round(Pipewire.defaultAudioSink.audio.volume * 100)

                if (vol === 0) {
                    return Quickshell.iconPath("audio-volume-off", true)
                } else {
                    if (vol > 0 && vol < 40) {
                        return Quickshell.iconPath("audio-volume-low", true)
                    } else if (vol < 70) {
                        return Quickshell.iconPath("audio-volume-medium", true)
                    } else {
                        return Quickshell.iconPath("audio-volume-high", true)
                    }
                }
            }

            implicitSize: 20
        }

        Text {
            id: volumeText
            
            color: palette.active.text

            text: Math.round(Pipewire.defaultAudioSink.audio.volume * 100) + "%"
        }
    }
    
    MouseArea {
        anchors.fill: parent

        onWheel: (event) => {
            if (!stopRegister.running) {
                stopRegister.running = true
                
                if (event.angleDelta.y > 0)
                    defaultSink.audio.volume += 0.05
                else
                    defaultSink.audio.volume -= 0.05

            }
        }
        
        onClicked: {
            toggleMixer.running = true
        }
    }
    
    Process {
        id: toggleMixer
        running: false
        command: ["qs", "ipc", "call", "mixerLoader", "toggleMixer"]
    }
    
    Timer {
        id: stopRegister
        running: false
        interval: wheelThresholdTime
    }
}