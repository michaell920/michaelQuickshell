# michaelQuickshell
Not meant to be used by anyone but myself, I don't read commits  
I will try to make my code more readable for human beings, feel free to take my stuffs for your configuration  
I barely commented the codes so sorry for people who went through the pain to comprehend  

## Broken stuff
- App Launcher

## Design philosophy
Waybar on steroids, theme agnostic (color is based on your qt theme)  

## Installation
Copy the "quickshell" folder to your ~/.config folder  

## System used for making this terrible Quickshell config:
Distro: Arch Linux  
Wayland compositor: Wayfire  
Quickshell version: I don't know I got the master branch one  

## You need these dependencies in order to work property:
### In Arch's repository
- cava  
- NetworkManager  
- playerctl  
- qt6-5compat (For graphical effects)  
- ddcutil (Setting screen brightness)  
- python
- gtk-launch (Opening desktop entries)
- lm-sensors (Getting CPU temperature)
- upower (setting power modes)  

### In AUR
- wayfire (Of course)  
- python-wayfire (Wayfire's IPC)

## Features
- MPRIS bar with progress and Cava window showing up when the bar is clicked on  
- Window title bar for Wayfire  
- Clock (of course)  
- Wifi Indicator (not finished yet)  
- CPU Temperature  
- Power mode indicator (click to change modes)  
- External desktop monitor bar (scroll to control brightness)  
- Systemtray

## Known issues
MPRIS progress bar not updating accurately sometimes
App launcher sucked, it doesn't work properly

## Screenshots
<img width="2560" height="1440" alt="20250810_22h51m09s_grim" src="https://github.com/user-attachments/assets/c8da9ef5-adc8-4dd8-ba21-36165bbe4d32" />
<img width="2560" height="1440" alt="20250810_23h16m54s_grim" src="https://github.com/user-attachments/assets/b9512b28-c3b2-4d67-9da0-ef8a2402de34" />

