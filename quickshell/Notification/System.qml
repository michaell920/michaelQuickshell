
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
}