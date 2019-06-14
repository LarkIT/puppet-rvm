# RVM's GPG key import

class rvm::gnupg_key(
  $key_id = $rvm::params::gnupg_key_id,
  $key_server = $rvm::params::key_server) inherits rvm::params {

  #gnupg_key { "rvm_D39DC0E3":
  #  ensure     => present,
  #  key_id     => '0xD39DC0E3',
  #  user       => 'root',
  #  key_server => $key_server,
  #  key_type   => public,
  #}

  gnupg_key { "rvm_39499BDB":
    ensure     => present,
    key_id     => '0x39499BDB',
    user       => 'root',
    key_server => $key_server,
    key_type   => public,
  }

}
