
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

import QtQuick
import QtQuick.Layouts

import QtQml.Models


Scope {
    id: notificationSystem
    

    Popup {} 
    
    LazyLoader {
        id: panelLoader
        active: notifPanelOn

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

            // I don't append the notification instead because the appended value
            // couldn't be updated, so a reference is appended instead
            // For example: blueman battery notifications
            
            notificationsList.append({
                "notif": notification,
                "icon": notification.appIcon,
                "summary": notification.summary,
                "body": notification.body
            })
            
            notifCount += 1
        }
    }
}