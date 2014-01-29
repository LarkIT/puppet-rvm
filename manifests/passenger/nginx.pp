class rvm::passenger::nginx(
  $ruby_version,
  $version,
  $rvm_prefix = '/usr/local/',
  $nginx_prefix = '/opt/nginx',
  $mininstances = '1',
  $maxpoolsize = '6',
  $poolidletime = '300',
  $maxinstancesperapp = '0',
  $spawnmethod = 'smart-lv2'
) {

  case $::operatingsystem {
    Ubuntu,Debian: { include rvm::passenger::nginx::ubuntu::pre }
    CentOS,RedHat: { include rvm::passenger::nginx::centos::pre }
  }

  class {
    'rvm::passenger::gem':
      ruby_version => $ruby_version,
      version => $version,
  }

  user {
    'nginx':
      ensure    => 'present',
      shell     => '/sbin/nologin',
      gid       => 'nginx',
      home      => '/opt/nginx',
      system    => 'true',
      require   => Group['nginx'];
  }

  group {
    'nginx':
      ensure    => 'present',
      system    => 'true',
  }

  # TODO: How can we get the gempath automatically using the ruby version
  # Can we read the output of a command into a variable?
  # e.g. $gempath = `usr/local/rvm/bin/rvm ${ruby_version} exec rvm gemdir`
  $gempath = "${rvm_prefix}rvm/gems/${ruby_version}/gems"
  $binpath = "${rvm_prefix}rvm/bin/"

  case $::operatingsystem {
    Ubuntu,Debian: { $passenger_post_class = 'rvm::passenger::nginx::ubuntu::post' }
    CentOS,RedHat: { $passenger_post_class = 'rvm::passenger::nginx::centos::post' }
  }

  if !defined(Class["$passenger_post_class"]) {
    class { "$passenger_post_class":
      ruby_version       => $ruby_version,
      version            => $version,
      rvm_prefix         => $rvm_prefix,
      nginx_prefix       => $nginx_prefix,
      mininstances       => $mininstances,
      maxpoolsize        => $maxpoolsize,
      poolidletime       => $poolidletime,
      maxinstancesperapp => $maxinstancesperapp,
      spawnmethod        => $spawnmethod,
      gempath            => $gempath,
      binpath            => $binpath;
    }
  }
}
