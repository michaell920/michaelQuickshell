
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
	required property PwNode node;

	// bind the node so we can read its properties
	PwObjectTracker { objects: [ node ] }

	RowLayout {

		IconImage {
			source: {
				const icon = node.properties["application.icon-name"] ?? "audio-volume-high-symbolic";
				return Quickshell.iconPath(icon, true)
			}
			implicitSize: 20
		}

		Text {
			Layout.maximumWidth: 500
			
			elide: Text.ElideRight

			text: {
				// application.name -> description -> name
				const app = node.properties["application.name"] ?? (node.description != "" ? node.description : node.name);
				const media = node.properties["media.name"];
				return media != undefined ? `${app} - ${media}` : app;
			}
			
			color: palette.active.text
		}

		Button {
			text: node.audio.muted ? "unmute" : "mute"
			onClicked: node.audio.muted = !node.audio.muted
		}
	}

	RowLayout {
		Label {
			Layout.preferredWidth: 50
			text: `${Math.floor(node.audio.volume * 100)}%`
			
			color: palette.active.text
		}

		Slider {
			Layout.fillWidth: true
			value: node.audio.volume
			onValueChanged: node.audio.volume = value
		}
	}
}
