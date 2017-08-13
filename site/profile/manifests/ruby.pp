class profile::ruby {
  include ruby
  include ruby::dev
  include epel

  $packages = ['gcc', 'gcc-c++', 'make', 'automake', 'autoconf', 'zlib-devel', 'cmake', 'ruby-devel']

  package { $packages:
    ensure => present,
  }

  package { 'nokogiri':
    ensure   => '1.6.8.1',
    provider => gem,
  }

  if $facts['os']['name'] == 'RedHat' {
    yumrepo { 'rhui-REGION-rhel-server-optional':
      enabled => 1,
      before  => Package['ruby-devel'],
    }
  }
}
