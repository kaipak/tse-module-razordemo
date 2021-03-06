class razordemo (
  $dnsmasq_config_dir  = $razordemo::params::dnsmasq_config_dir,
  $dnsmasq_config_file = $razordemo::params::dnsmasq_config_file,
  $brokers             = hiera_hash('razordemo::brokers_hash', $razordemo::params::brokers),
  $tasks               = hiera_hash('razordemo::tasks_hash', $razordemo::params::tasks),
  $tags                = hiera_hash('razordemo::tags_hash', $razordemo::params::tags),
  ) inherits razordemo::params { 
  require pe_razor
  
  class{ 'razordemo::forward_ipv4': } ->
  file_line { '/etc/hosts':
    ensure => 'absent',
    path   => '/etc/hosts',
    line   => "127.0.1.1 $::fqdn $::hostname",
    notify => Service['dnsmasq'],
  } ~>
  class {'razordemo::dnsmasq':
    dnsmasq_config_dir  => $dnsmasq_config_dir,
    dnsmasq_config_file => $dnsmasq_config_file,   
  } ~>
  class {'razordemo::config':
    brokers  => $brokers,
    tasks    => $tasks,
    tags     => $tags,
  } 
  include razordemo::client
}
