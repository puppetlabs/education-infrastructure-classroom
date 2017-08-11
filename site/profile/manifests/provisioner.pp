class profile::provisioner (
  $psk = $profile::params::psk,
) inherits profile::params {
  require profile::nginx

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { "${profile::nginx::docroot}/bootstrap.sh":
    ensure  => file,
    content => template('profile/provisioning/bootstrap.sh.erb'),
  }

  file { '/etc/puppetlabs/puppet/autosign.rb':
    ensure  => file,
    mode    => '0755',
    content => file('profile/provisioning/autosign.rb'),
  }

  file { '/etc/puppetlabs/puppet/psk':
    ensure  => file,
    content => $psk,
  }

  ini_setting { 'autosign':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'master',
    setting => 'autosign',
    value   => '/etc/puppetlabs/puppet/autosign.rb',
#    notify  => Service['pe-puppetserver'],
  }

  # refresh the server, if it's in the catalog
  Ini_setting['autosign'] ~> Service<| title == 'pe-puppetserver' |>

}