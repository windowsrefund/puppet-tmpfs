Puppet tmpfs module
===================

Manage the contents of /etc/default/tmpfs 

Supported Platforms
-------------------

- Debian GNU/Linux

USAGE
-----

        tmpfs { '/run/tmpfs: 
            size => '256M',
            dirs => [ '/tmp', '/var/log', '/var/run', '/var/lock' ],
            opts => [ 'nodev', 'noexec' ],
        }

