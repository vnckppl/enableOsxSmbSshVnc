#!/bin/bash

# 2019-03-05

# Enable SSH - SMB - VNC - Remote Management

# SSH
# http://osxdaily.com/2016/08/16/enable-ssh-mac-command-line/
echo $(tput setaf 1)"SSH:"$(tput sgr0)
if [ "$(sudo systemsetup -getremotelogin | grep Off)" ]; then
    echo "Remote login via SSH is disabled"
    echo "Enabling remote login via SSH"
    sudo systemsetup -setremotelogin on
elif [ "$(sudo systemsetup -getremotelogin | grep On)" ]; then
    echo "Remote login via SSH is enabled"
    echo "Disabling remote login via SSH"
    sudo systemsetup -setremotelogin off    
else echo "Something went wrong. Try again."
fi


# SMB
# https://apple.stackexchange.com/questions/136649/enable-smb-sharing-from-command-line
echo $(tput setaf 1)"SMB:"$(tput sgr0)
if [ "$(sudo launchctl list | grep smbd)" ]; then
    echo "File sharing via SMB is enabled"
    echo "Disabling file sharing via SMB"
    sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.smbd.plist
else \
    echo "File sharing via SMB is disabled"
    echo "Enabling file sharing via SMB"
    sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.smbd.plist
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server.plist EnabledServices -array disk
fi


# VNC
# https://www.techrepublic.com/article/how-to-enable-screen-sharing-on-macs-via-terminal/
# https://apple.stackexchange.com/questions/200549/enable-screensharing-via-ssh-and-setting-password
# echo $(tput setaf 1)"VNC:"$(tput sgr0)
# if [ "$(sudo launchctl list | grep -i screensharing)" ]; then
#     echo "Screen sharing via VNC is enabled"
#     echo "Disabling screen sharing via VNC"
#     sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
# else \
#     echo "Screen sharing via VNC is disabled"
#     echo "Enabling screen sharing via VNC"
#     sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
# fi

# Remote Management
# https://apple.stackexchange.com/questions/30238/how-to-enable-os-x-screen-sharing-vnc-through-ssh
echo $(tput setaf 1)"Remote management:"$(tput sgr0)
ks="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"
if [ "$(sudo launchctl list | grep -i screensharing)" ]; then
    echo "Screen sharing via Remote Management is enabled"
    echo "Disabling screen sharing via Remote Management"
    sudo ${ks} \
         -deactivate \
         -configure \
         -access \
         -off
else \
    echo "Screen sharing via Remote Management is disabled"
    echo "Enabling screen sharing via Remote Management"
    sudo ${ks} \
         -activate \
         -configure \
         -access \
         -on \
         -clientopts \
         -setvnclegacy \
         -vnclegacy yes \
         -clientopts \
         -setvncpw \
         -vncpw master \
         -restart \
         -agent \
         -privs \
         -all
fi


