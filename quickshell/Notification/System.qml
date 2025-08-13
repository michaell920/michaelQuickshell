
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
                "icon": notification.appIcon,
                "summary": notification.summary,
                "body": notification.body,
                
                "notif": notification
            })
            
            updateCount()
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