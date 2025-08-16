
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower

import QtQuick
import QtQuick.Layouts


RowLayout {
    id: root

    Repeater {
        model: UPower.devices
        
        Rectangle {
            required property UPowerDevice modelData
            property var isLaptopBattery: modelData.isLaptopBattery
        
            color: palette.active.window
        
            implicitWidth: layout.width + (textPadding * 2)
            Layout.fillHeight: true
            
            radius: borderRadius

            visible: isLaptopBattery
            
            RowLayout {
                id: layout
                
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                
                anchors.leftMargin: textPadding
                

                IconImage {
                    implicitSize: 16
                    source: Quickshell.iconPath("battery-" + String(Math.round(modelData.state)).padStart(3, '0'), true)
                    //source: modelData.iconName
                }
                
                Text {
                    id: battery
                    
                    text: (Math.round(modelData.percentage * 100)) + "%"
                    
                    color: palette.active.text
                }
            }
        }
    }
}
