#!/bin/bash

## NOTE: You do not need to do this if you want to *use* Quickstart.  
#
#  You can save yourself some time with the instructions here:
#
#  http://<url>


## This script will build a Quickstart Development Environment
#
# The Quickstart 3.0 build environment is Ubuntu 12.04.
# If you're not using Ubuntu 12.04, this may not work.
#
# Documentation: http://<url>



# ############################################## User configurable settings

# Linux user to be created.  /home/quickstart
QS_USER="quickstart"

# Machine hostname
QS_HOST_NAME="qs3" 

# Name of Virtual Machine in Virtualbox
QS_VBOX_NAME="Quickstart 2.0 (build $RANDOM)" 

# Desktop(s) to load and configure: Cinnamon, Gnome
QS_DESKTOPS="All"

# Development projects to load: All, Drupal, Symfony
QS_PROJECTS="All"

# Which images to build: All, DevLocal, TestLocal, ProdLocal
QS_IMAGES="All"



# ############################################## Build script - do not modify

## Help

if [ "$1" == "--help" ] ; then
echo "
Quickstart 3.0 build script.  Usage:

build.sh [linux user] [host name] [vbox name] [desktops] [dev projects]

Parameters:
 [linux user]   = Linux user created for working.  Defaults to 'quickstart'.
 [host name]    = Host name in linux.  Defaults to 'qs3'.
 [vbox name]    = Name in Virtualbox.  Defaults to 'Quickstart 2.0 (build random)'
 [desktops]     = comma separated list of desktops to load: All, Cinnamon, Gnome.  Defaults to 'All'
 [dev projects] = comma separated list of dev projects to load: All, Drupal, Symfony
 [machines]     = comma separated list of images to build: All, DevLocal, TestLocal, ProdLocal.  Defaults to 'All'

Example:
 bash build.sh ghandi \"My Machine\" \"Cinnamon, Gnome\", \"Drupal, Symfony\", \"DevLocal\"

"; exit; fi

## Parameters

if [ "$1" != "" ] ; then QS_USER=$1; fi
if [ "$2" != "" ] ; then QS_HOST_NAME=$2; fi
if [ "$2" != "" ] ; then QS_VBOX_NAME=$3; fi
if [ "$3" != "" ] ; then QS_DESKTOPS=$4; fi
if [ "$4" != "" ] ; then QS_PROJECTS=$5; fi
if [ "$5" != "" ] ; then QS_IMAGES=$6; fi

## Confirmation

echo "
*** Do you want to build Quickstart 3.x with: 
  * Linux User:   $QS_USER
  * Host name:    $QS_HOST_NAME
  * VBox name:    $QS_VBOX_NAME
  * Desktops:     $QS_DESKTOPS
  * Dev projects: $QS_PROJECTS
  * Images:       $QS_IMAGES"
read -p "Are you sure?  (ctrl-c to quit)"


## Install VirtualBox, Vagrant, and Python if necessary

# Verify/install Virtualbox   https://www.virtualbox.org/wiki/Downloads
command -v VBoxManage >/dev/null 2>&1 || { sudo apt-get update; sudo apt-get install virtualbox; }
# Verify/install vagrant      http://downloads.vagrantup.com/
command -v vagrant >/dev/null 2>&1 || { sudo apt-get install vagrant; }
# Verify/install python
command -v python >/dev/null 2>&1 || { sudo apt-get install python; }


## Build new VirtualMachine

# Set variables for Puppet.  Puppet Facter makes available in .pp
FACTER_quickstart_user=QS_USER
FACTER_quickstart_host_name=QS_HOST_NAME
FACTER_quickstart_vbox_name=QS_VBOX_NAME
FACTER_quickstart_desktops=QS_DESKTOPS
FACTER_quickstart_projects=QS_PROJECTS
FACTER_quickstart_images=QS_IMAGES

# FIXME where do we bootstrap in our Puppet files?

# FIXME where do we strap in our bach config files for dev envs

# Use the vagrant project in this repo
#  Uses /Vagrantfile
#  downloads and caches Ubuntu 12.04 LTS box from vagrantup.com
#  runs /manifests/build/precise64.pp
# FIXME This needs to build the Vagrantfile depending on QS_IMAGES
vagrant up


## This VM is done
exit
vagrant halt  #kernel updates


## Wrap it up
# Remove vagrant login public key
vagrant up
# FIXME This needs to change for multi-vm
vagrant ssh -c "rm ~/.ssh/authorized_keys; sudo poweroff"

# Get the Virtualbox name from .vagrant using python's json parser
V_NAME=`cat .vagrant | python -c 'import json,sys;obj=json.loads(sys.stdin.read());print obj["'"active"'"]["'"default"'"]'`
# Wait for machine to power off
sleep 20
# Rename it and take it out of Vagrant
VBoxManage modifyvm $V_NAME --name "$QS_NAME"
rm .vagrant

