#!/bin/bash

## NOTE: You do not need to do this if you want to *use* Quickstart.  

#  You can save yourself some time with the instructions here:
#  http://<url>


## This script will build a Quickstart Development Environment

# It is designed to run on on an Ubuntu/Debian based computer
# If you're not using Ubuntu/Debian, it may not work.
QS_USER=quickstart
QS_NAME="Quickstart 2.0 (build $RANDOM)" 
QS_DESKTOP="MATE"
QS_PROJECTS="All"

if [ "$2" != "" ] ; then
QS_USER=$2; fi
if [ "$3" != "" ] ; then
QS_NAME=$3; fi
if [ "$4" != "" ] ; then
QS_DESKTOP=$4; fi
QS_TEMP="$3 $4 $5 $6 $7 $8 $9"
if [ "$QS_TEMP" != "      " ] ; then
QS_PROJECTS=$QS_TEMP; fi
echo "*** Building: $QS_USER $QS_NAME $QS_DESKTOP $QS_PROJECTS"


## Install VirtualBox and Vagrant

# Verify/install Virtualbox   https://www.virtualbox.org/wiki/Downloads
command -v VBoxManage >/dev/null 2>&1 || { sudo apt-get install virtualbox; }
# Verify/install vagrant      http://downloads.vagrantup.com/
command -v vagrant >/dev/null 2>&1 || { sudo apt-get install vagrant; }
# Verify/install python
command -v python >/dev/null 2>&1 || { sudo apt-get install python; }


## Build new VirtualMachine

# Set variables for Puppet.  Puppet Facter makes available in .pp
FACTER_quickstart_user=QS_USER
FACTER_quickstart_desktop=QS_DESKTOP
FACTER_quickstart_projects=QS_PROJECTS

# Use the vagrant project in this repo
#  Uses /Vagrantfile
#  downloads and caches Ubuntu 12.04 LTS box from vagrantup.com
#  runs /manifests/build/precise64.pp
vagrant up


## This VM is done
exit
vagrant halt  #kernel updates


## Wrap it up
# Remove vagrant login public key
vagrant up
vagrant ssh -c "rm ~/.ssh/authorized_keys; sudo poweroff"

# Get the Virtualbox name from .vagrant using python's json parser
V_NAME=`cat .vagrant | python -c 'import json,sys;obj=json.loads(sys.stdin.read());print obj["'"active"'"]["'"default"'"]'`

sleep 30

# Rename it and take it out of Vagrant
VBoxManage modifyvm $V_NAME --name "$QS_NAME"
rm .vagrant

