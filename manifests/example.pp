tmpfs { '/dev/shm': 
	size => '256M',
	dirs => [ '/tmp', '/var/log', '/var/run', '/var/lock' ],
	opts => [ 'nodev', 'noexec' ],
}
