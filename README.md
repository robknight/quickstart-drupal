Quickstart:
======

Quickstart Development Environment for PHP

"A pre-packaged downloadable Development Environment for LAMP/PHP/Drupal"

"Why spend time learning WAMP/XAMP/MAMP/Cygwin/etc, when websites are deployed on LAMP? Why hack up your Mac/Windows computer?"


More Information:
======
Drupal Project Page: http://drupal.org/project/quickstart

Drupal Project Documentation: http://drupal.org/node/788080


Folders:
======
/.           = Quickstart Drush extension
/docs        = Documentation on the Drupal and Drush development process
/build       = Scripts to build a new downloadable image
/build/docs  = Documentation on the image build process


To Start Quickly:
======
1) Install Virtualbox (depends on your OS)
    [link to help]

2) Download for your project:
    [link tbd]

3) Double-click the downloaded file


To Build your own:
======
**** This documentation is not yet implemented ****

0) Quickstart is GPL 2.0, please consult the LICENSE.txt for how to use.

1) The build environment is Ubuntu 12.04 with Cinnamon

2) Install software: Virtualbox, Vagrant, Git
sudo apt-get install virtualbox vagrant git-core

3) Clone this repo

4) Run build.sh [QuickstartUser] [VBoxName] [Desktop] [Projects...]

    [QuickstartUser] name of the unix user in the virtual machine
      Defaults to 'quickstart'

    [name] is the name of the machine in VirtualBox
      Defaults to 'Quickstart 2.0'

    [desktop] is one of these popular desktops:
      Defaults to 'MATE'

      Supported:
        MATE
        Unity

      Experimental:
        Yours?

    [projects...] are one or more of these PHP Projects (not implemented yet)
      Default to 'All'

      Supported:
        All
        Drupal
        Symfony2
        Wordpress

      Experimental:
        Yours?


Want to add your favorite PHP Project?
======
1) Fork this repo!

2) Copy the /Puppet/PhpProjects/Template directory to your project name

3) Use Puppet to install your project's development files

4) Test it out and send a pull request!


Want to add your favorite Desktop Environment?
======
1) Fork this repo!

2) Copy the /Puppet/DesktopEnvironments/Template folder to a new folder

3) Use Puppet to install from a Ubuntu Server 12.04 LTS 64bit image.

4) Test it out and send a pull request!



