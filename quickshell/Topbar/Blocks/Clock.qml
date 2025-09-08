
import Quickshell

import QtQuick
import QtQuick.Layouts

Rectangle {
    property var clockFormat: "HH:mm"
    property var clockAltFormat: "yyyy-MM-dd"
    
    property var format: clockFormat
    
    property bool triggered: false


    color: palette.active.window
    
    implicitWidth: clockText.contentWidth + (textPadding * 2)
    Layout.fillHeight: true
    
    radius: borderRadius
    
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Text {
        id: clockText
        
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: textPadding

        color: palette.active.text

        text: Qt.formatDateTime(clock.date, format)
        font.bold: true
    }
    
    MouseArea {
        anchors.fill: parent

        onClicked: {
            triggered = !triggered
            format = triggered ? clockAltFormat : clockFormat
        }
    }
}