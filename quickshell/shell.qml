//@ pragma UseQApplication

import Quickshell
import Quickshell.Services.Notifications

import "Topbar"
import "Lockscreen"
import "Windows" as Windows
import "Notification" as Notification

ShellRoot {

    // Variable settings
    property var borderRadius: 10
    property var windowGap: 10
    property var textPadding: 5
    
    property var animateTime: 100
    property var cavaAnimateTime: 100

    // States
    property int notifCount: 0
    
    property bool notifPanelOn: false

    
    Topbar {}

    Windows.AppLauncher {}
    Windows.VolumeMixer {}

    NotificationServer {
        id: notifServer

        actionsSupported: true
        actionIconsSupported: true
        imageSupported: true
        
        onNotification: notification => {
            notification.tracked = true
        }
    }

    Notification.System {}
    
    Lockscreen {}
}
