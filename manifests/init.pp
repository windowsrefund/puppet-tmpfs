# $quiet - Mount without writing to /etc/mtab.
# Useful when /etc is on a read-only filesystem.
define tmpfs (
  $size,
  $dirs,
  $opts,
  $quiet = false) {
  # Ensures augeas is available
  package { 'augeas-lenses':
    ensure => installed
  }

  augeas { 'tmpfs':
    require => Package['augeas-lenses'],
    context => $operatingsystem ? {
      debian  => '/files/etc/default/tmpfs',
      default => fail('os not supported'),
    },
    changes => [
      "set SHM_SIZE \'\"${size}\"\'",
      "set MNT_TMPFS \'\"${name}\"\'",
      inline_template("set DIRS \'\"<%= @dirs.join(' ') %>\"\'"),
      inline_template("set OPTS_TMPFS \'\"<%= @opts.join(',') %>\"\'"),
      inline_template("set QUIET \'\"<%= 1 if @quiet %>\"\'"),
      ],
    notify  => Exec['tmpfs']
  }

  exec { 'tmpfs':
    command     => '/etc/init.d/tmpfs start',
    subscribe   => File['tmpfs-init'],
    refreshonly => true,
  }

  file { 'tmpfs-init':
    path   => '/etc/init.d/tmpfs',
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => 0755,
    source => 'puppet:///modules/tmpfs/global/tmpfs',
  }

  service { 'tmpfs':
    enable  => true,
    require => File['tmpfs-init'],
  }

}