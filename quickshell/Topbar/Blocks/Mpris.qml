
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Mpris

import QtQuick
import QtQuick.Layouts

import Qt5Compat.GraphicalEffects


// Mpris is not updating accurately sometimes

RowLayout {
    id: layout

    property int progressHeight: 2
    property int cavaHeight: 200
    property int gap: 10
    property int maxWidth: 800
    

    Layout.maximumWidth: maxWidth
    
    property list<color> cavaColors: [
        "#81c8be",
        "#99d1db",
        "#85c1dc",
        "#8caaee",
        "#ca9ee6",
        "#f4b8e4",
        "#ea999c",
        "#e78284"
    ]

    property list<var> cavaVal: []
    property int cavaLength: 0


    Layout.alignment: Text.AlignHCenter
    
    spacing: textPadding

    
    
    Repeater {
        model: Mpris.players.values
        
        Rectangle {
            id: mprisBox
        
            required property MprisPlayer modelData

            color: palette.active.window

            Layout.preferredWidth: mprisLayout.width + (textPadding * 2)
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            radius: borderRadius

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: mprisBox.width
                    height: mprisBox.height
                    radius: mprisBox.radius
                }
            }
            
            Rectangle {
                id: mprisProgress

                anchors.left: parent.left
                anchors.bottom: parent.bottom

                height: progressHeight
                
                color: palette.active.accent
            }

            RowLayout { 
                id: mprisLayout
        
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
        
                anchors.leftMargin: 5
                
                IconImage {
                    id: mprisIcon
                    
                    source: (modelData.isPlaying ? "image://icon/media-playback-start" : "image://icon/media-playback-pause")
                    implicitSize: 20
                }
                    
                Text {
                    id: mprisTitleText
                    
                    Layout.maximumWidth: mprisBox.width - mprisIcon.width - textPadding * 2

                    color: palette.active.text
        
                    text: modelData.trackTitle

                    elide: Text.ElideRight
                }
            }

            MouseArea {
                anchors.fill: parent

                onReleased: {
                    cava.visible = !cava.visible
                }
            }

            FrameAnimation {
                running: modelData.playbackState === MprisPlaybackState.Playing

                onTriggered: () => {
                    var percentage = (modelData.position / modelData.length)
                    mprisProgress.width = mprisBox.width * percentage
                }
            }
        }
    }

    PopupWindow {
        id: cava
        
        // Set to maxWidth by default
        implicitWidth: maxWidth
        implicitHeight: cavaHeight
        
        anchor {
            window: layout.QsWindow.window
            adjustment: PopupAdjustment.Flip
            
        }
        
        anchor.onAnchoring: {
            const window = layout.QsWindow.window

            // (mprisBox.width - this.width) / 2 equals center!
            const widgetRect = window.contentItem.mapFromItem(layout, (layout.width - this.width) / 2, layout.height + gap, layout.width, layout.height)
    
            anchor.rect = widgetRect
        }
        
        color: "Transparent"
        

        Rectangle {
            id: cavaBg
            anchors.fill: parent
            
            color: palette.active.window

            radius: borderRadius
            opacity: 0.7
        }

        Item {
            anchors.fill: parent

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: cavaBg.width
                    height: cavaBg.height
                    radius: borderRadius
                }
            }

            RowLayout {
                anchors.fill: parent

                spacing: 0
                
                Repeater {

                    model: cavaLength
                    
                    Rectangle {
                        required property int index
                        
                        Layout.alignment: Text.AlignTop
                        Layout.topMargin: cavaBg.height * (1 - cavaVal[index])

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        
                        color: cavaColors[0]
                        
                        gradient: Gradient {
                            GradientStop { position: 1; color: cavaColors[0] }
                            GradientStop { id: endColor; position: 0; color: cavaColors[7] }
                        }


                        Behavior on Layout.topMargin {
                            NumberAnimation {
                                duration: 100
                                
                                onRunningChanged: {
                                    var levels = 1 / (cavaColors.length - 1)
                                    var curLevel = Math.round(cavaVal[index] / levels)
                                    endColor.color = cavaColors[curLevel]
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Process {
        running: cava.visible
        command: ["/home/michaellee/.config/quickshell/scripts/cava.py"]
                
        stdout: SplitParser {
            onRead: (data) => {
                const cavaData = data.slice(2, -1).split(/, /)
                cavaLength = cavaData.length
                cavaVal = cavaData
            } 
        }
    } 
}