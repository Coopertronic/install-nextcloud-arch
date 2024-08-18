#!/bin/bash

if !(command -v ctos-functions &>/dev/null); then
    cat <<EOT
The script failed because of the following ERROR!!

You need to have ctos-functions installed to run this script!!

Download it from:

    https://raw.githubusercontent.com/Coopertronic/useful-bash-functions/main/usr/bin/ctos-functions

Or you can install the ctos-side-repo, which will
install ctos-functions.

Download the install script from here from here:

    https://raw.githubusercontent.com/Coopertronic/install-ctos-side-repo/main/install-ctos-side-repo.sh

EOT
    exit 1
fi

##  Needed functions - You need the ctos-functions package installed.
source ctos-functions

##  This script installs the LXQT desktop on Archlinux
check_root

##  An array with the packages listed
pkgList=(
    'xorg'
    'lxqt xdg-utils ttf-freefont sddm'
    'libpulse libstatgrab libsysstat lm_sensors network-manager-applet oxygen-icons pavucontrol-qt'
    'firefox mpv filezilla leafpad xscreensaver archlinux-wallpaper'
    'git-helper ctos-lxqt-skel'
)

##  Runs through the install list
for installThis in "${pkgList[@]}"; do
    to_continue
    if !(do_install $installThis); then
        line_break
        echo "ERROR!!"
        echo "$installThis"
        echo "have NOT been installed."
        line_break
        something_wrong
    else
        line_break
        echo "Success!!"
        echo "installed: $installThis"
        line_break
    fi
    to_continue
done
## An array with the services that need to be Enabled.
servicesList=(
    'sddm'
    'NetworkManager'
)

##  Runs through the services that need to be Enabled
for enableThis in "${servicesList[@]}"; do
    if !(test_service $enableThis); then
        echo "the service $enableThis is not active."
        echo "enabling now"
        if !(systemctl enable $enableThis); then
            something_wrong
        else
            echo "Successfuly enable $enableThis."
        fi
    else
        echo "$enableThis is already enabled."
        echo "Doing nothing."
    fi
done

#if !(test_service sddm); then
#    echo "the service sddm is not active."
#    echo "enabling now"
#    if !(systemctl enable sddm); then
#        something_wrong
#    else
#        echo "Successfuly enable sddm."
#    fi
#else
#    echo "sddm is already enabled."
#    echo "Doing nothing."
#fi

#if !(systemctl enable sddm); then
#    something_wrong
#else
#    echo "SDDM enabled"
#fi
#systemctl enable sddm
#systemctl enable NetworkManager

line_break
echo
echo "LXQT has been installed."
echo
line_break
echo "Do you want to reboot?"
to_continue
reboot
