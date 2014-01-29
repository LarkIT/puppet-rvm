class rvm::passenger::nginx::centos::post(
  $ruby_version,
  $version,
  $rvm_prefix = '/usr/local/',
  $nginx_prefix = '/opt/nginx',
  $mininstances = '1',
  $maxpoolsize = '6',
  $poolidletime = '300',
  $maxinstancesperapp = '0',
  $spawnmethod = 'smart-lv2',
  $gempath,
  $binpath
) {
  exec {
    'passenger-install-nginx-module':
      command   => "${rvm::passenger::nginx::binpath}rvm ${rvm::passenger::nginx::ruby_version} exec passenger-install-nginx-module --auto --auto-download --prefix=$nginx_prefix",
      environment => 'HOME=/root',
      provider => shell,
      creates   => "${nginx_prefix}/sbin/nginx",
      #unless   => "/bin/bash -c (if [ -x ${nginx_prefix}/sbin/nginx ]; then ${nginx_prefix}/sbin/nginx -V 2>&1 | grep ${rvm::passenger::nginx::gempath}/passenger-${rvm::passenger::nginx::version} 1>/dev/null; else exit 1; fi)",
      unless   => "if [ -x ${nginx_prefix}/sbin/nginx ]; then ${nginx_prefix}/sbin/nginx -V 2>&1 | grep ${rvm::passenger::nginx::gempath}/passenger-${rvm::passenger::nginx::version} 1>/dev/null; else exit 1; fi",
      logoutput => 'on_failure',
      require   => [Rvm_gem['passenger']];
  }

  file {
    'nginx.conf':
      path    => "${nginx_prefix}/conf/nginx.conf",
      ensure  => file,
      content => template('rvm/passenger-nginx.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      require => Exec['passenger-install-nginx-module'];

    "${nginx_prefix}/conf/conf.d":
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      require => Exec['passenger-install-nginx-module'];
  }

  file {
    '/etc/init.d/nginx':
      ensure  => file,
      content => template('rvm/passenger-nginx.init.centos.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      require => Exec['passenger-install-nginx-module'];
  }

  service {
    'nginx':
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
      subscribe  => File['nginx.conf'],
      require    => [File['/etc/init.d/nginx'],User['nginx'], Group['nginx']];
  }
}
