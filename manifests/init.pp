class zipkin (

    String $user                                                   = 'zipkin',
    String $group                                                  = 'zipkin',
    $uid                                                           = undef,
    $gid                                                           = undef,
    Stdlib::Absolutepath $shell                                    = '/bin/false',
    Boolean $manage_user                                           = true,
    Stdlib::Absolutepath $installdir                               = '/opt/zipkin',
    Pattern[/^(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+)(|[a-z])$/] $version = '2.14.0',
    $javahome                                                      = undef ,
    $jvm_xms                                                       = '256m',
    $jvm_xmx                                                       = '1024m',
    $java_opts                                                     = '',
    Boolean $checksum_verify                                       = true,
    $service_manage                                                = true,
    $service_ensure                                                = running,
    $service_enable                                                = true,
    $service_notify                                                = undef,
    $service_subscribe                                             = undef,
    $stop_zipkin                                                   = 'service zipkin stop && sleep 15',

) inherits zipkin::params {

    Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

    if $javahome == undef {
        fail('You need to specify a value for $JAVA_HOME (zipkin::javahome).')
    }

    if defined('$::zipkin_version') {
        if versioncmp($version, $::zipkin_version) > 0 {
            notify { 'Attempting to upgrade Zipkin': }
            exec { $stop_zipkin: before => Class['zipkin::install'] }
        }
    }

    contain zipkin::install
    contain zipkin::service

    Class['zipkin::install']
    ~> Class['zipkin::service']

}
