
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

import QtQuick
import QtQuick.Layouts

import QtQml.Models


Scope {
    id: notificationSystem
    
    property bool popupVisible: true
    

    Popup {} 
    
    LazyLoader {
        id: panelLoader
        active: false

        Panel {}
    }

    ListModel {
        id: notificationsList
    }
    
    function updateCount() {
        notifCount = notificationsList.count
    }
    
    NotificationServer {
        actionsSupported: true
        actionIconsSupported: true
        imageSupported: true
        
        onNotification: notification => {
            notification.tracked = true

            notificationsList.append({
                "notif": notification
            })
            
            notifCount += 1
        }
    }
    
    IpcHandler {
        target: "panelLoader"
       
        function togglePanel() {
            panelLoader.active = !panelLoader.active
            popupVisible = !panelLoader.active
        }
    }
}