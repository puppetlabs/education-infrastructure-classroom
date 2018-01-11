class profile::html (
  $docroot = $profile::params::docroot,
) inherits profile::params {

  file { $docroot:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/profile/html',
    recurse => true,
  }

  ['index', 'classroom_tutorial'].each |String $page| {
    concat { "${docroot}/${page}.html":
      owner => 'root',
      group => 'root',
      mode  => '0644',
    }
    concat::fragment { "${page} header":
      target  => "${docroot}/${page}.html",
      order   => '01',
      content => file('profile/fragments/header.html'),
    }
    concat::fragment { "${page} footer":
      target  => "${docroot}/${page}.html",
      order   => '99',
      content => file('profile/fragments/footer.html'),
    }
  }

  # requirements validator & button
  concat::fragment { "Index fragment: requirements":
    target  => "${docroot}/index.html",
    order   => '10',
    content => file('profile/fragments/requirements.html'),
  }

  # help and faq
  concat::fragment { "Index fragment: docs":
    target  => "${docroot}/index.html",
    order   => '20',
    content => file('profile/fragments/docs.html'),
  }


  # tutorial
  concat::fragment { "Tutorial fragment: content":
    target  => "${docroot}/classroom_tutorial.html",
    order   => '10',
    content => file('profile/fragments/classroom_tutorial.html'),
  }

}
