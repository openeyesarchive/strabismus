class phpdev::apache {

  package { 'apache2':
    ensure  => present,
    require => Exec['apt-get update'],
  }

  service { 'apache2':
    ensure  => running,
    require => Package['apache2'],
  }

  file { '/etc/apache2/mods-enabled/rewrite.load':
     ensure => 'link',
     target => '/etc/apache2/mods-available/rewrite.load',
     require => Package['apache2'],
     notify  => Service['apache2'],
  }
  
  file { "local site":
    path    => '/etc/apache2/sites-available/000-default',
    ensure  => 'present',
    source => "puppet:///modules/phpdev/local.site.conf",
    require => Package['apache2'],
    notify  => Service['apache2'],
    mode    => 644,
  }
  
  file { "/var/www":
    ensure => 'directory',
    owner => 'vagrant',
    group => 'vagrant',
    require => Package['apache2'],
  }
 
  file {"/var/protected":
    ensure => 'link',
    target => '/srv/code/protected',
    owner => 'vagrant',
    group => 'vagrant',
  }

  file { '/var/www/index.html':
    require => [
      Package['apache2'],
      File['/var/protected'],
    ],
    ensure => 'absent',
  }
}
