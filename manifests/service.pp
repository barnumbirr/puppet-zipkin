# == Class: zipkin::service
#
# Install zipkin, See README.md for more.
#

class zipkin::service (

    Boolean $service_manage = $zipkin::service_manage,
    String $service_ensure  = $zipkin::service_ensure,
    Boolean $service_enable = $zipkin::service_enable,
    $service_notify         = $zipkin::service_notify,
    $service_subscribe      = $zipkin::service_subscribe,
    $service_file_location  = $zipkin::params::service_file_location,
    $service_file_template  = $zipkin::params::service_file_template,

) inherits zipkin::params {

    assert_private()

    if($::refresh_systemd) {
        include systemd::systemctl::daemon_reload
    }

    file { $service_file_location:
        content => template($service_file_template),
        mode    => '0755',
        notify  => [
            $::refresh_systemd ? {
                true    => Class['systemd::systemctl::daemon_reload'],
                default => undef
            }
        ],
    }

    if $zipkin::service_manage {
        service { 'zipkin':
            ensure    => $service_ensure,
            enable    => $service_enable,
            require   => File[$service_file_location],
            notify    => $service_notify,
            subscribe => $service_subscribe,
        }
    }
}
