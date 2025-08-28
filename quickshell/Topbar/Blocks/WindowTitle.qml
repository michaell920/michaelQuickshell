
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts


Rectangle {
    property var maxWidth: 500

    color: palette.active.window

    Layout.preferredWidth: layout.width + textPadding
    Layout.fillHeight: true

    radius: borderRadius
    
    RowLayout {
        id: layout 
        
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        
        spacing: textPadding

        IconImage {
            id: windowIcon

            Layout.alignment: Text.AlignLeft
            Layout.leftMargin: textPadding
            
            implicitSize: source != "" ? 20 : 0
            
            source: ""
        }

        Text {
            id: windowTitle
            
            Layout.alignment: Text.AlignLeft
            Layout.maximumWidth: maxWidth


            color: palette.active.text
            text: ""
            
            elide: Text.ElideRight
        }

        Process {
            running: true 
            environment: ({
                PATH: Quickshell.shellDir + "/venv/bin/"
            })
            command: [ Quickshell.shellDir + "/scripts/windowMonitor.py" ]
            stdout: SplitParser {
                onRead: data => {
                    try {
                        const obj = JSON.parse(data)
                        
                        const iconPath = Quickshell.iconPath(obj["app-id"], true)
                        
                        if (iconPath != "") {
                            windowTitle.text = obj["title"]
                            windowIcon.source = iconPath
                        }

                    } catch (exception) {
                        if (exception instanceof SyntaxError) {
                            windowTitle.text = ""
                            windowIcon.source = ""
                        }
                    }
                }
            }
        }
    }
}