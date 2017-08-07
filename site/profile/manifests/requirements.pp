class profile::requirements {
  require showoff
  require profile::ruby
  include profile::nginx

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

  showoff::presentation { 'requirements':
    path      => "${showoff::root}/requirements",
    subscribe => File['presentation'],
  }

  file { '/etc/nginx/conf.d/default.conf':
    ensure => file,
    source => 'puppet:///modules/profile/nginx.proxy.conf',
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

  selinux::boolean { 'httpd_can_network_connect':
    ensure => 'on',
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

  # home page blurb
  concat::fragment { "Index fragment: requirements":
    target  => "${profile::nginx::docroot}/index.html",
    order   => '10',
    content => epp('profile/html/requirements.html.epp'),
  }

  file { "${profile::nginx::docroot}/ssltest.html":
    ensure => file,
    source => 'puppet:///modules/profile/ssltest.html',
  }

  file { "${profile::nginx::docroot}/PuppetLogo_small.png":
    ensure => file,
    source => 'puppet:///modules/profile/PuppetLogo_small.png',
  }

}