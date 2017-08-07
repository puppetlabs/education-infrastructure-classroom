class profile::ruby {
  include ruby
  include ruby::dev
  include epel

  $packages = ['gcc', 'gcc-c++', 'make', 'automake', 'autoconf', 'zlib-devel', 'cmake']

  package { $packages:
    ensure => present,
  }

  package { 'nokogiri':
    ensure   => '1.6.8.1',
    provider => gem,
  }

  yumrepo { 'rhui-REGION-rhel-server-optional':
    enabled => 1,
  }

}