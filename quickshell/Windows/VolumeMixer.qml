
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pipewire

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "VolumeMixer" as Widgets


Scope {
	property var maxHeight: 300

	LazyLoader {
		id: mixerLoader
		active: false

		PanelWindow {
			color: "Transparent"

			implicitWidth: view.contentWidth + textPadding * 2
			implicitHeight: Math.min(layout.height, maxHeight) + textPadding * 2
		

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
		
					RowLayout {
						
						Text {
							text: "Default output: "
							
							color: palette.active.text
						}

						ComboBox {
							id: sinkMenu
	
							Layout.fillWidth: true
	
							model: Pipewire.nodes.values.filter((i) => i.isSink && !i.isStream)
							
							delegate: Rectangle {
								id: holder
	
								required property var modelData
	
								property var nickname: modelData.nickname
	
								implicitWidth: sinkMenu.popup.availableWidth
								implicitHeight: nodeText.height
								
								color: "Transparent"
								
								
							 	Text {
									id: nodeText
	
									text: nickname != "" ? nickname : name
									
									color: palette.active.text
								}
	
								MouseArea {
									anchors.fill: parent
									
									hoverEnabled: true
									
									onEntered: {
										holder.color = palette.active.highlight	
										nodeText.color = palette.active.highlightedText
									}
									
									onExited: {
										holder.color = "Transparent"
										nodeText.color = palette.active.text
									}
	
									onClicked: {
										Pipewire.preferredDefaultAudioSink = modelData
										sinkMenu.popup.visible = false
									}
								
								}
							}
							
							displayText: Pipewire.defaultAudioSink.nickname
						}
					}

					// get a list of nodes that output to the default sink
					PwNodeLinkTracker {
						id: linkTracker
						node: Pipewire.defaultAudioSink
					}
		
					Widgets.MixerEntry {
						node: Pipewire.defaultAudioSink
					}
		
					Rectangle {
						Layout.fillWidth: true
						color: palette.active.text
						implicitHeight: 1
					}
		
					Repeater {
						model: linkTracker.linkGroups
		
		
						Widgets.MixerEntry {
							required property PwLinkGroup modelData
							// Each link group contains a source and a target.
							// Since the target is the default sink, we want the source.
							node: modelData.source
						}
					}
				}
				
				onActiveFocusChanged: {
					mixerLoader.active = this.focus
				}
				
				Component.onCompleted: {
					view.forceActiveFocus()
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