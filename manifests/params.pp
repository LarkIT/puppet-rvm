# Default module parameters
class rvm::params($manage_group = true) {

  $manage_rvmrc = $::osfamily ? {
    'Windows' => false,
    default   => true
  }

  $group = $::operatingsystem ? {
    default => 'rvm',
  }

  $proxy_url = undef
  $no_proxy = undef
 
  # ignored param, using gnupg module
  $gpg_package = $::kernel ? {
    /(Linux|Darwin)/ => 'gnupg2',
    default          => undef,
  }
}
