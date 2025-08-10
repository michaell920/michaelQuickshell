
import Quickshell

import QtQuick
import QtQuick.Layouts

Rectangle {
    color: palette.active.base
    
    implicitWidth: clockText.contentWidth + (textPadding * 2)
    Layout.fillHeight: true
    
    radius: borderRadius
    
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        id: clockText
        
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: textPadding

        color: palette.active.text

        text: Qt.formatDateTime(clock.date, "HH:mm")
        font.bold: true
    }
}