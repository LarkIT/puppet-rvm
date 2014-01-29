class rvm::passenger::nginx::centos::pre {
  # Dependencies
  #if ! defined(Package['nginx-passenger-1.2.6-3.0.19'])       { package { 'nginx-passenger-1.2.6-3.0.19':       ensure => installed } }
	## nginx needs recompiled to add the passenger module. I am not sure whether it would be useful to RPM it.
}
