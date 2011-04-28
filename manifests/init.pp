# $quiet - Mount without writing to /etc/mtab. Useful when /etc
# is on a read-only filesystem.
define tmpfs($size, $dirs, $opts, $quiet = false) {

	# Ensures augeas is available 
	include augeas

	# Ensure sysv-rc is available
	include sysvrc

	File {
		owner => 'root',
		group => 'root',
	}

	augeas { tmpfs:
		require => Package[$augeas::packages],
		context => $operatingsystem ? {
			debian => '/files/etc/default/tmpfs',
			default => undef,
		},
		changes => [
			"set SHM_SIZE \'\"$size\"\'",
			"set MNT_TMPFS \'\"$name\"\'",
			inline_template("set DIRS \'\"<%= dirs.join(' ') %>\"\'"),
			inline_template("set OPTS_TMPFS \'\"<%= opts.join(',') %>\"\'"),
			inline_template("set QUIET \'\"<%= 1 if quiet %>\"\'"),
		],

	}

	exec { tmpfs:
		command => '/etc/init.d/tmpfs start',
		subscribe => File[tmpfs-init],
		refreshonly => true,
	}

	file { tmpfs-init:
		ensure => present,
		path => '/etc/init.d/tmpfs',
		source => 'puppet:///modules/tmpfs/global/tmpfs',
		mode => 0755,
	}

/* 
	# This can be used by clients who are not affected by bug 5908
	service { tmpfs:
		enable => true,
		require => File[tmpfs-init],
	}
		
	# The file resource below should can be removed if using the service
	# resource 
*/
	file { tmpfs-init-link:
		ensure => link,
		path => '/etc/rcS.d/S01tmpfs',
		require => Package[$sysvrc::packages],
		target => '/etc/init.d/tmpfs',
	}

}
