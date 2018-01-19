class profile::requirements {
  require epel
  require showoff
  require profile::ruby
  include profile::nginx
  include profile::html

  Class['profile::ruby'] -> Class['showoff']

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { 'presentation':
    ensure  => directory,
    path    => "${showoff::root}/requirements",
    recurse => true,
    owner   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/profile/presentation',
  }

  file { "${showoff::root}/requirements/stats":
    ensure => directory,
    owner  => $showoff::user,
    mode   => '0755',
  }

  showoff::presentation { 'requirements':
    path      => "${showoff::root}/requirements",
    subscribe => File['presentation'],
  }

  nginx::resource::location { 'classroom.puppet.com/shell/login':
    ensure        => present,
    rewrite_rules => ['^/shell/login http://$http_host/shell/login/ permanent'],
    location      => '/shell/login',
    server        => 'classroom.puppet.com',
  }

  nginx::resource::location { 'classroom.puppet.com/shell/login/':
    ensure             => present,
    location           => '/shell/login/',
    server             => 'classroom.puppet.com',
    proxy              => 'http://127.0.0.1:4200/',
    proxy_http_version => '1.1',
    proxy_set_header   => [
      'Upgrade $http_upgrade',
      'Connection "Upgrade"',
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-NginX-Proxy true',
    ],
    proxy_read_timeout => '43200000',
  }

  # We'll just serve an image from this port to validate access.
  # Gitea is a standard web app, so we'll just trust that it works.
  nginx::resource::server { 'classroom.puppet.com gitea':
    www_root    => $profile::nginx::docroot,
    listen_port => 3000,
  }
  # We'll just serve an image from this port to validate RDP access.
  # It would be unusual for a firewall to allow port access but then do
  # packet inspection to block the RDP protocol, so I think this is sufficient.
  nginx::resource::server { 'classroom.puppet.com rdp':
    www_root    => $profile::nginx::docroot,
    listen_port => 3389,
  }

  selinux::boolean { 'httpd_can_network_connect':
    ensure => 'on',
  }
  selinux::port { 'allow nginx on rdp port':
    ensure   => 'present',
    seltype  => 'http_port_t',
    protocol => 'tcp',
    port     => 3389,
  }

  class { 'abalone':
    method      => 'command',
    command     => '/bin/sl',
    port        => '4200',
    autoconnect => false,
  }

  package { 'sl':
    ensure => present,
  }

}
