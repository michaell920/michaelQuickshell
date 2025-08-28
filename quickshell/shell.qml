//@ pragma UseQApplication

import Quickshell

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

    Notification.System {}
    
    Lockscreen {}
}
