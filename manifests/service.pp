# == Class: zipkin::service
#
# This class manages the Zipkin service.
#
# This class should not be used directly under normal circumstances
# Instead, use the *zipkin* class.
#

class zipkin::service (

    $service_manage         = $zipkin::service_manage,
    $service_ensure         = $zipkin::service_ensure,
    $service_enable         = $zipkin::service_enable,
    $refresh_systemd        = $zipkin::params::refresh_systemd,
    $service_file_location  = $zipkin::params::service_file_location,
    $service_file_template  = $zipkin::params::service_file_template,

) inherits zipkin::params {

    assert_private()

    if($::refresh_systemd) {
        include systemd::systemctl::daemon_reload
    }

    file { $service_file_location:
        content => template($service_file_template),
        mode    => '0644',
        notify  => [
            $::refresh_systemd ? {
                true    => Class['systemd::systemctl::daemon_reload'],
                default => undef
            }
        ],
    }

    if $zipkin::service_manage {
        service { 'zipkin':
            ensure  => $service_ensure,
            enable  => $service_enable,
            require => File[$service_file_location],
        }
    }
}
