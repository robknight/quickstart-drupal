/* Default resource properties */
File { owner => 0, group => 0, mode => 0644 }
Exec { path => "/bin:/sbin:/usr/bin:/usr/sbin" }
package { ['puppet', 'gem', 'ruby']:
        ensure => installed,
}

/* Set welcome message */
file { '/etc/motd':
  content => "Welcome to Quickstart 2.0!\n"
}

/* Update now. dist-upgrade allows for packages to be added/removed.  autoremove deletes unneeded packages */
/*exec {"sudo apt-get -yq update; sudo apt-get -yq dist-upgrade; sudo apt-get -yq autoremove":}*/

/* Configure automatic updates */
file { '/etc/apt/apt.conf.d/10periodic':
  content => "
APT::Periodic::Enable \"1\";
APT::Periodic::Update-Package-Lists \"1\";
APT::Periodic::Download-Upgradeable-Packages \"1\";
APT::Periodic::AutocleanInterval \"5\";
APT::Periodic::Unattended-Upgrade \"1\";
"
}

/* Make our default user */
/* Install source code control */
exec { "gem install ruby-shadow":}
user { "quickstart":
  name      => $quickstart_user,
  ensure    => present,
  password  => $quickstart_user,
  groups    => ["www-data", "root", "admin"],
  managehome => true,  
}

/* Add to /etc/sudoers
exec { "echo \"${quickstart_user} ALL=(ALL) NOPASSWD: ALL\" | sudo tee -a /etc/sudoers > /dev/null":
  unless => ["sudo grep \"^${quickstart_user}\" /etc/sudoers"]
} */

/* Install source code control */
package { ['git-core']:
        ensure => installed,
}

/*include basics
include user

include desktop
include lamp
include lamp-tools

include browsers
include ides



/* Install basic tools 
package { ['wget', 'curl']:
        ensure => installed,
}
*/

