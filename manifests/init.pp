# Class stack_logstash
#
class stack_logstash (

  $repo_class                       = '::stack_logstash::repo',

  $syslog_class                     = '::stack_logstash::syslog::rsyslog',
  $syslog_server                    = false,
  $syslog_server_port               = '5544',

  $elasticsearch_class              = undef,
  $elasticsearch_protocol           = 'http',
  $elasticsearch_server             = '',
  $elasticsearch_server_port        = '9200',

  $logstash_class                   = undef,

  $kibana_class                     = undef,

  $monitor_class                    = undef,
  $firewall_class                   = undef,

  ) {

  $repo_class_require = $repo_class ? {
    ''        => undef,
    undef     => undef,
    default   => Class[$repo_class],
  }

  $real_elasticsearch_server = $elasticsearch_server ? {
    # query_nodes('Class[elasticsearch]{tags=stack_logstash}',ipaddress), #
    # TODO: Fix query
    ''      => query_nodes('Class[elasticsearch]',ipaddress),
    default => $elasticsearch_server,
  }

  if $repo_class {
    class { $repo_class: }
  }

  if $syslog_class {
    include $syslog_class
  }

  if $logstash_class {
    class { $logstash_class:
      require => $repo_class_require,
    }
  }

  if $elasticsearch_class {
    class { $elasticsearch_class:
      require => $repo_class_require,
    }
  }

  if $kibana_class {
    class { $kibana_class:
      require => $repo_class_require,
    }
  }

  if $monitor_class {
    include $monitor_class
  }

  if $firewall_class {
    include $firewall_class
  }

}
