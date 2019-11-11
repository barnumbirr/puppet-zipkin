# == Class: zipkin::params
#
# This class manages parameters for Zipkin.
#
# This class should not be used directly under normal circumstances
# Instead, use the *zipkin* class.
#

class zipkin::params {

    case $facts['service_provider'] {
        'systemd': {
            case $facts['os']['family'] {
                /RedHat/: {
                    $service_file_location = '/lib/systemd/system/zipkin.service'
                    $service_file_template = 'zipkin/zipkin.systemd.erb'
                    $refresh_systemd       = true
                }

                /Debian/: {
                    $service_file_location = '/lib/systemd/system/zipkin.service'
                    $service_file_template = 'zipkin/zipkin.systemd.erb'
                    $refresh_systemd       = true
                }
                default: { fail('Only osfamily Debian and Redhat are supported for systemd.') }
            }
        }
        default: {
            $service_file_location = '/etc/init.d/zipkin'
            $service_file_template = 'zipkin/zipkin.initscript.erb'
            $refresh_systemd       = false
        }
    }
}
