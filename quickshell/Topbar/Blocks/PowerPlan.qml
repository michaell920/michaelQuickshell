
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Qt5Compat.GraphicalEffects


// I would like to make a popupwindow that is not overlapping the root rectangle

Rectangle {
    id: root
    
    property var gap: 10
    property var modeStr: {
        "Performance": "performance",
        "PowerSaver": "power-saver",
        "Balanced": "balanced"
    }


    implicitWidth: layout.width + (textPadding * 2)
    Layout.fillHeight: true
    
    radius: borderRadius
    
    color: palette.active.base
    
    
    RowLayout {
        id: layout        

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        anchors.leftMargin: textPadding
        
        IconImage {
            id: powerIcon

            Layout.alignment: Text.AlignLeft

            implicitSize: 16
            
            source: ""
        }
        
        Text {
            Layout.alignment: Text.AlignLeft
            
            text: PowerProfile.toString(PowerProfiles.profile)

            color: palette.active.text
            
            onTextChanged: {
                powerIcon.source = Quickshell.iconPath("power-profile-" + modeStr[this.text] + "-symbolic")
            }
        }
    }
    
    PopupWindow {
        id: menu

        implicitWidth: root.width
        implicitHeight: powerMenu.contentHeight
        
        color: "Transparent"
  
        anchor {
            window: root.QsWindow.window
            adjustment: PopupAdjustment.Flip
        }

        anchor.onAnchoring: {
            const window = root.QsWindow.window
            const widgetRect = window.contentItem.mapFromItem(root, 0, root.height + gap, root.width, root.height)
    
            anchor.rect = widgetRect
        }
            
        Menu {
            id: powerMenu
            
            MenuItem { text: "PowerSaver" }
            MenuItem { text: "Balanced" }
            
            Component.onCompleted: {
                if (PowerProfiles.hasPerformanceProfile)
                    this.addItem(performance)
            }
            
            onAboutToHide: {
                PowerProfiles.profile = PowerProfile[this.contentData[currentIndex].text]
            }
        }

        MenuItem { 
            id: performance
            text: "Performance"
        }
    }
    
    MouseArea {
        anchors.fill: parent
        
        onClicked: (event) => {
            menu.visible = !menu.visible
            powerMenu.popup()
        }
    }
}