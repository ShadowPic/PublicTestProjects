#!/bin/bash
#####################################################################################################
# Script_Name : Std-Xrdp-install-0.5.3.sh
# Description : Perform an automated standard installation of xrdp
# on ubuntu 18.04 and later
# Date : October 2018
# written by : Griffon
# Web Site :http://www.c-nergy.be - http://www.c-nergy.be/blog
# Version : 0.6
# History : 0.6   - Added support for Ubuntu 19.04 
#                 - New code for Look'n feel using xsessionrc method
#                 - New code for enabling Sound Redirection - compiling from source 
#                 - Removed -g parameter  
#         : 0.5.3 - Using Unoffical xRDP packages for Ubuntu 18.04.2 issue
#         : 0.5.2 - Quick Fix for Ubuntu 18.04.2
#         : 0.5.1 - Add support to Ubuntu 18.10 
#         : 0.5   - Add logic to enable sound redirection 
#                 - re-write code logic to include functions
#                 - Removed support for Ubuntu 17.10 as reached end of support
#         : 0.4   - Add logic to fix GDM lock screen + minor change
#         : 0.3   - Adding logic to fix theme and extensions for any users login through xrdp
#           0.2   - Added Logic for Ubuntu 17.10 and 18.04 detection 
#                 - Updated the polkit section
#                 - New formatting and structure  
#           0.1   - Initial Script       
# Disclaimer : Script provided AS IS. Use it at your own risk....
####################################################################################################


#---------------------------------------------------#
#  Detecting if Parameters passed to script .... 
#---------------------------------------------------#

while getopts s:u: option 
do 
 case "${option}" 
 in 
 s) fixSound=${OPTARG};;
 u) unofficialRepo=${OPTARG};; 
 esac 
done 

#---------------------------------------------------#
# Script Version information Displayed              #
#---------------------------------------------------#

echo
/bin/echo -e "\e[1;36m   !-------------------------------------------------------------!\e[0m"
/bin/echo -e "\e[1;36m   !   Standard XRDP Installation Script  - Ver 0.6              !\e[0m"
/bin/echo -e "\e[1;36m   !   Written by Griffon - May 2019 - www.c-nergy.be            !\e[0m"
/bin/echo -e "\e[1;36m   !-------------------------------------------------------------!\e[0m"
echo

#--------------------------------------------------------------------------#
# -----------------------Function Section - DO NOT MODIFY -----------------#
#--------------------------------------------------------------------------#

#-----------------------------------------------------#
# Function 0  - Quick and Dirty Patch Ubuntu 18.04.2  #
#-----------------------------------------------------#

install_xservercore() 
{
echo
/bin/echo -e "\e[1;33m   !----------------------------------------------------------!\e[0m"
/bin/echo -e "\e[1;33m   !   Installing xserver-xorg-core Packages...Proceeding...  !\e[0m"
/bin/echo -e "\e[1;33m   !----------------------------------------------------------!\e[0m"
echo
sudo apt-get install xserver-xorg-core -y
echo
/bin/echo -e "\e[1;33m   !----------------------------------------------------------!\e[0m"
/bin/echo -e "\e[1;33m   !   Installing xserver-xorg-input-all pkg...Proceeding...  !\e[0m"
/bin/echo -e "\e[1;33m   !----------------------------------------------------------!\e[0m"
echo
sudo apt-get -y install xserver-xorg-input-all 
}

#---------------------------------------------------#
# Function 1  - Install xRDP Software.... 
#---------------------------------------------------#

install_xrdp() 
{
echo
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
/bin/echo -e "\e[1;33m   !   Installing XRDP Packages...Proceeding...  !\e[0m"
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
echo
sudo apt-get install xrdp -y 
}

#---------------------------------------------------#
# Function 2 - Install Gnome Tweak Tool.... 
#---------------------------------------------------#

install_tweak() 
{
echo
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
/bin/echo -e "\e[1;33m   !   Installing Gnome Tweak...Proceeding...    !\e[0m"
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
echo
sudo apt-get install gnome-tweak-tool -y
}

#--------------------------------------------------------------------#
# Fucntion 3 - Allow console Access ....(seems optional in u18.04)
#--------------------------------------------------------------------#

allow_console() 
{
echo
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
/bin/echo -e "\e[1;33m   !   Granting Console Access...Proceeding...   !\e[0m"
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
echo
sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config
}

#---------------------------------------------------#
# Function 4 - create policies exceptions .... 
#---------------------------------------------------#

create_polkit()
{
echo
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
/bin/echo -e "\e[1;33m   !   Creating Polkit File...Proceeding...      !\e[0m"
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
echo

sudo bash -c "cat >/etc/polkit-1/localauthority/50-local.d/45-allow.colord.pkla" <<EOF
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes

[Allow Package Management all Users]
Identity=unix-user:*
Action=org.debian.apt.*;io.snapcraft.*;org.freedesktop.packagekit.*;com.ubuntu.update-notifier.*
ResultAny=no
ResultInactive=no
ResultActive=yes
EOF

}

#---------------------------------------------------#
# Function 5 - Fixing Theme and Extensions .... 
#---------------------------------------------------#

fix_theme()
{
echo
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
/bin/echo -e "\e[1;33m   !   Fix Theme and extensions...Proceeding...  !\e[0m"
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
echo
sudo sed -i.bak "4 a #Improved Look n Feel Method\ncat <<EOF > ~/.xsessionrc\nexport GNOME_SHELL_SESSION_MODE=ubuntu\nexport XDG_CURRENT_DESKTOP=ubuntu:GNOME\nexport XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg\nEOF\n" /etc/xrdp/startwm.sh
echo
}

#---------------------------------------------------#
# Function 6 - Enable Sound Redirection .... 
#---------------------------------------------------#

enable_sound()
{
echo
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
/bin/echo -e "\e[1;33m   !   Enabling Sound Redirection...             !\e[0m"
/bin/echo -e "\e[1;33m   !---------------------------------------------!\e[0m"
echo

# Step 1 - Enable Source Code Repository
sudo apt-add-repository -s 'deb http://be.archive.ubuntu.com/ubuntu/ '$codename' main restricted'
sudo apt-add-repository -s 'deb http://be.archive.ubuntu.com/ubuntu/ '$codename' restricted universe main multiverse'
sudo apt-add-repository -s 'deb http://be.archive.ubuntu.com/ubuntu/ '$codename'-updates restricted universe main multiverse'
sudo apt-add-repository -s 'deb http://be.archive.ubuntu.com/ubuntu/ '$codename'-backports main restricted universe multiverse'
sudo apt-add-repository -s 'deb http://be.archive.ubuntu.com/ubuntu/ '$codename'-security main restricted universe main multiverse'
sudo apt-get update

# Step 2 - Install Some PreReqs
sudo apt-get install git libpulse-dev autoconf m4 intltool build-essential dpkg-dev -y
sudo apt build-dep pulseaudio -y

# Step 3 -  Download pulseaudio source in /tmp directory - Do not forget to enable source repositories
cd /tmp
sudo apt source pulseaudio

# Step 4 - Compile
pulsever=$(pulseaudio --version | awk '{print $2}')
cd /tmp/pulseaudio-$pulsever
sudo ./configure

# step 5 - Create xrdp sound modules
sudo git clone https://github.com/neutrinolabs/pulseaudio-module-xrdp.git
cd pulseaudio-module-xrdp
sudo ./bootstrap 
sudo ./configure PULSE_DIR="/tmp/pulseaudio-$pulsever"
sudo make

#Step 6 copy files to correct location (as defined in /etc/xrdp/pulse/default.pa)
cd /tmp/pulseaudio-$pulsever/pulseaudio-module-xrdp/src/.libs
sudo install -t "/var/lib/xrdp-pulseaudio-installer" -D -m 644 *.so
sudo install -t "/usr/lib/pulse-$pulsever/modules" -D -m 644 *.so
echo

}

#--------------------------------------------------------------------------#
# -----------------------END Function Section             -----------------#
#--------------------------------------------------------------------------#


#--------------------------------------------------------------------------#
#------------                 MAIN SCRIPT SECTION       -------------------#  
#--------------------------------------------------------------------------#

#---------------------------------------------------#
#-- Step 0 - Try to Detect Ubuntu Version.... 
#---------------------------------------------------#

version=$(lsb_release -sd) 
codename=$(lsb_release -sc) 

echo
/bin/echo -e "\e[1;33m   |-| Detecting Ubuntu version        \e[0m"

if  [[ "$version" = *"Ubuntu 18.04"* ]];
then
/bin/echo -e "\e[1;32m       |-| Ubuntu Version : $version\e[0m"
echo
elif [[ "$version" = *"Ubuntu 18.10"* ]];
then
/bin/echo -e "\e[1;32m       |-| Ubuntu Version : $version\e[0m"
echo
elif [[ "$version" = *"Ubuntu 19.04"* ]];
then
/bin/echo -e "\e[1;32m       |-| Ubuntu Version : $version\e[0m"
echo
else
/bin/echo -e "\e[1;31m  !------------------------------------------------------------!\e[0m"
/bin/echo -e "\e[1;31m  ! Your system is not running Ubuntu 18.04 Edition and later  !\e[0m"
/bin/echo -e "\e[1;31m  ! The script has been tested only on Ubuntu 18.04 and later  !\e[0m"
/bin/echo -e "\e[1;31m  ! The script is exiting...                                   !\e[0m"              
/bin/echo -e "\e[1;31m  !------------------------------------------------------------!\e[0m"
echo
exit
fi

/bin/echo -e "\e[1;33m   |-| Detecting Parameters        \e[0m"

#Detect if argument passed
if [ "$fixSound" = "yes" ]; 
then 
/bin/echo -e "\e[1;32m       |-| Sound Redirection Option...: [YES]\e[0m"
else
/bin/echo -e "\e[1;32m       |-| Sound Redirection Option...: [NO]\e[0m"
fi

if [ "$unofficialRepo" = "yes" ]; 
then 
/bin/echo -e "\e[1;32m       |-| Unofficial Repo...........: [YES]\e[0m"
else
/bin/echo -e "\e[1;32m       |-| Unofficial Repo...........: [NO]\e[0m"
fi
echo

#---------------------------------------------------------#
# Step 2 - Executing the installation & config tasks .... #
#---------------------------------------------------------#

echo
/bin/echo -e "\e[1;36m   !-------------------------------------------------------------!\e[0m"
/bin/echo -e "\e[1;36m   !   Installation Process starting....                         !\e[0m"
/bin/echo -e "\e[1;36m   !-------------------------------------------------------------!\e[0m"
echo
/bin/echo -e "\e[1;33m   |-| Proceed with installation.....       \e[0m"
echo 

if  [[ "$version" = *"Ubuntu 18.04.2"* ]];
then
/bin/echo -e "\e[1;32m       |-| Ubuntu Version : $version\e[0m"
echo
/bin/echo -e "\e[1;36m   !-------------------------------------------------------------!\e[0m"
/bin/echo -e "\e[1;36m   !  Applying Installation Patch for Ubuntu 18.04.2 Only        !\e[0m"
/bin/echo -e "\e[1;36m   !-------------------------------------------------------------!\e[0m"
echo
if [ "$unofficialRepo" = "yes" ];
then
/bin/echo -e "\e[1;32m   	=>  Downloading Unofficial xRDP packages (Thiago Martins)      !\e[0m"
echo
sudo add-apt-repository ppa:martinx/xrdp-hwe-18.04 -y
sudo apt-get update
install_xrdp
install_tweak
allow_console
create_polkit
fix_theme
else
/bin/echo -e "\e[1;32m   	=>  Downgrading to previous xserver-xorg-* packages            !\e[0m"
echo
install_xservercore
install_xrdp
install_tweak
allow_console
create_polkit
fix_theme
fi
else
install_xrdp
install_tweak
allow_console
create_polkit
fix_theme
fi

if [ "$fixSound" = "yes" ]; 
then 
enable_sound
fi

#---------------------------------------------------#
# Step 9 - Credits .... 
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;36m   !------------------------------------------------------------------------------!\e[0m"
/bin/echo -e "\e[1;36m   ! Installation Completed                                                       !\e[0m" 
/bin/echo -e "\e[1;36m   ! Please test your xRDP configuration.A Reboot Might be required...            !\e[0m"
/bin/echo -e "\e[1;36m   ! Written by Griffon - May 2019 - Ver 0.6 - Std-Xrdp-Install-0.6.sh            !\e[0m"
/bin/echo -e "\e[1;36m   !                                                                              !\e[0m"
/bin/echo -e "\e[1;36m   ! Thanks to Thiago Martins who provided Updated xRDP packages for 18.04.2 :-)  !\e[0m"
/bin/echo -e "\e[1;36m   !------------------------------------------------------------------------------!\e[0m"
echo





