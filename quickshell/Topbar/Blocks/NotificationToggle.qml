
import Quickshell
import Quickshell.Widgets
import Quickshell.Io

import QtQuick
import QtQuick.Layouts


Rectangle {
    color: palette.active.window
    
    implicitWidth: icon.width + (textPadding * 2)
    Layout.fillHeight: true
    
    radius: borderRadius
    

    IconImage {
        id: icon
        
        anchors.centerIn: parent
        
        implicitSize: 20
        source: notifCount == 0 ? Quickshell.iconPath("indicator-messages", true) : Quickshell.iconPath("indicator-messages-new", true)

        MouseArea {
            anchors.fill: parent
            
            onClicked: {
                togglePanel.running = true
            }
        }
    }
    
    Process {
        id: togglePanel
        
        running: false
        command: ["qs", "ipc", "call", "panelLoader", "togglePanel"]
    }

}