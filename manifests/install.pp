# == Class: zipkin::install
#
# This class manages the installation of Zipkin.
#
# This class should not be used directly under normal circumstances
# Instead, use the *zipkin* class.
#

class zipkin::install {

    include 'archive'

    if $zipkin::manage_user {
        group { $zipkin::group:
            ensure => present,
            system => true,
            gid    => $zipkin::gid,
        }
        -> user { $zipkin::user:
            ensure           => present,
            comment          => 'Zipkin distributed tracing system account',
            shell            => $zipkin::shell,
            password         => '*',
            password_min_age => '0',
            password_max_age => '99999',
            managehome       => false,
            system           => true,
            uid              => $zipkin::uid,
            gid              => $zipkin::gid,

        }
    }

    if ! defined(File[$zipkin::install_dir]) {
        file { $zipkin::install_dir:
            ensure => 'directory',
            owner  => $zipkin::user,
            group  => $zipkin::group,
        }
    }

    if $zipkin::use_slim {
        $source       = "https://repo1.maven.org/maven2/io/zipkin/zipkin-server/${zipkin::version}/zipkin-server-${zipkin::version}-slim.jar"
        $checksum_url = "https://repo1.maven.org/maven2/io/zipkin/zipkin-server/${zipkin::version}/zipkin-server-${zipkin::version}-slim.jar.sha1"
        if $zipkin::java_opts =~ /(?i:KAFKA)/ or $zipkin::java_opts =~ /(?i:RABBIT)/ {
            fail('The slim build of Zipkin doesn\'t support messaging transports like Kafka or RabbitMQ (https://github.com/openzipkin/zipkin#zipkin-slim).')
        }
    } else {
        $source       = "https://repo1.maven.org/maven2/io/zipkin/zipkin-server/${zipkin::version}/zipkin-server-${zipkin::version}-exec.jar"
        $checksum_url = "https://repo1.maven.org/maven2/io/zipkin/zipkin-server/${zipkin::version}/zipkin-server-${zipkin::version}-exec.jar.sha1"
    }

    archive { 'zipkin':
        ensure          => 'present',
        source          => $source,
        checksum_url    => $checksum_url,
        checksum_verify => $zipkin::checksum_verify,
        checksum_type   => 'sha1',
        path            => "${zipkin::install_dir}/${zipkin::jar_name}",
        require         => [User[$zipkin::user],File[$zipkin::install_dir]],
        user            => $zipkin::user,
    }

    file { "${zipkin::install_dir}/${zipkin::jar_name}":
        ensure  => 'file',
        owner   => $zipkin::user,
        group   => $zipkin::group,
        mode    => '0644',
        require => [
            User[$zipkin::user],
            Group[$zipkin::group],
            Archive[zipkin],
        ],
    }
}
