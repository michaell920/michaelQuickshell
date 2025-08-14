
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pipewire

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls


Scope {

	LazyLoader {
		id: mixerLoader
		active: false

		PanelWindow {
			property var maxHeight: 300
		
			color: "Transparent"
			
			implicitWidth: view.contentWidth + textPadding * 2
			implicitHeight: Math.min(layout.height, maxHeight) + textPadding * 2
			
			WlrLayershell.namespace: "Audio Mixer"
		
			Rectangle {
				anchors.fill: parent
				color: palette.active.window
				
				radius: borderRadius
			}
		
			ScrollView {
				id: view
		
				anchors.fill: parent
		
				ColumnLayout {
					id: layout
		
					anchors.top: parent.top
					anchors.left: parent.left
					anchors.topMargin: textPadding
					anchors.leftMargin: textPadding
		
					// get a list of nodes that output to the default sink
					PwNodeLinkTracker {
						id: linkTracker
						node: Pipewire.defaultAudioSink
					}
		
					MixerEntry {
						node: Pipewire.defaultAudioSink
					}
		
					Rectangle {
						Layout.fillWidth: true
						color: palette.active.text
						implicitHeight: 1
					}
		
					Repeater {
						model: linkTracker.linkGroups
		
		
						MixerEntry {
							required property PwLinkGroup modelData
							// Each link group contains a source and a target.
							// Since the target is the default sink, we want the source.
							node: modelData.source
						}
					}
				}
			}
		}
	}
	
	IpcHandler {
		target: "mixerLoader"
		
		function toggleMixer() {
			mixerLoader.active = !mixerLoader.active
		}
	}
}