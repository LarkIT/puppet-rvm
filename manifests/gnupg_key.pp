# RVM's GPG key import

class rvm::gnupg_key(
  $key_id = $rvm::params::gnupg_key_id,
  $key_server = $rvm::params::key_server) inherits rvm::params {

  #gnupg_key { "rvm_409B6B1796C275462A1703113804BB82D39DC0E3":
  #  ensure     => present,
  #  key_id     => "409B6B1796C275462A1703113804BB82D39DC0E3",
  #  user       => 'root',
  #  key_server => $key_server,
  #  key_type   => public,
  #}

  gnupg_key { "rvm_105BD0E739499BDB":
    ensure     => present,
    key_id     => "105BD0E739499BDB",
    user       => 'root',
    key_server => $key_server,
    key_type   => public,
  }

}
