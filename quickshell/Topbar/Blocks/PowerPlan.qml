
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
    
    z: 1
    
    property var gap: 10
    property var modeStr: {
        "Performance": "performance",
        "PowerSaver": "power-saver",
        "Balanced": "balanced"
    }


    implicitWidth: layout.width + (textPadding * 2)
    Layout.fillHeight: true
    
    radius: borderRadius
    
    color: palette.active.window
    
    
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

        implicitWidth: powerMenu.width
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

            width: {
                var result = 0
                var padding = 0
                for (var i = 0; i < count; i++) {
                    var item = contentData[i]
                    result = Math.max(item.contentItem.implicitWidth + item.padding, result)
                    padding = Math.max(item.padding, padding)
                    console.log(item.contentItem.text + " : " + item.contentItem.implicitWidth)
                }
                return result + padding * 2
            }

            MenuItem { text: "PowerSaver" }
            MenuItem { text: "Balanced" }
            MenuItem { 
                id: performance
                text: "Performance" 
            }
            
            onAboutToShow: {
                if (!PowerProfiles.hasPerformanceProfile)
                    this.removeItem(performance)
                    
                console.log(powerMenu.width)
            }

            onAboutToHide: {
                PowerProfiles.profile = PowerProfile[this.contentData[currentIndex].text]
            }
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