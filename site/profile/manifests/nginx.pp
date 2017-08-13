class profile::nginx (
  $docroot = $profile::params::docroot,
) inherits profile::params {
  include nginx

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/nginx/ssl':
    ensure => directory,
  }
  file { '/etc/nginx/ssl/classroom.puppet.com.pem':
    ensure => file,
    owner  => 'nginx',
    source => "/etc/puppetlabs/puppet/ssl/certs/${::trusted['certname']}.pem",
  }
  file { '/etc/nginx/ssl/classroom.puppet.com.key':
    ensure => file,
    owner  => 'nginx',
    mode   => '0600',
    source => "/etc/puppetlabs/puppet/ssl/private_keys/${::trusted['certname']}.pem",
  }
  
  # gross hack so nginx can start prior to failing over to this node
  host { 'classroom.puppet.com':
    ip => $facts['ec2_metadata']['public-ipv4'],
  }

  nginx::resource::server { 'classroom.puppet.com':
    www_root => $docroot,
    ssl      => true,
    ssl_cert => '/etc/nginx/ssl/classroom.puppet.com.pem',
    ssl_key  => '/etc/nginx/ssl/classroom.puppet.com.key',
  }

#   nginx::resource::location { 'classroom.puppet.com':
#     ensure        => present,
#     location      => '/',
#     www_root      =>
#     server        => 'classroom.puppet.com',
#   }

  file { $docroot:
    ensure => directory,
  }

  concat { "${docroot}/index.html":
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  concat::fragment { 'index header':
    target  => "${docroot}/index.html",
    order   => '01',
    content => epp('profile/html/header.html.epp'),
  }
  concat::fragment { 'index footer':
    target  => "${docroot}/index.html",
    order   => '100',
    content => epp('profile/html/footer.html.epp'),
  }

}
