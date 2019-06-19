# puppet-zipkin

[![Puppet Forge](https://img.shields.io/puppetforge/v/barnumbirr/zipkin.svg)](https://forge.puppetlabs.com/barnumbirr/zipkin)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/barnumbirr/zipkin.svg)](https://forge.puppetlabs.com/barnumbirr/zipkin)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/barnumbirr/zipkin.svg)](https://forge.puppetlabs.com/barnumbirr/zipkin)

1. [Description](#description)
2. [Usage - Configuration options](#basic-usage)
    * [Class Parameters](#class-parameters)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [License](#license)

## Description

This module installs, configures and upgrades [Apache Zipkin](https://zipkin.apache.org/) via Puppet. Zipkin is a distributed tracing system.
It helps gather timing data needed to troubleshoot latency problems in microservice architectures. It manages both the collection and lookup of this data.

## Usage

### Beginning with Apache Zipkin

```puppet
class { '::java':
  package => 'openjdk-8-jre',
  version => '8u111-b14-2~bpo8+1',
} ->
class { '::elasticsearch':
} ->
class { 'zipkin':
    # JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
    javahome => '/usr/lib/jvm/java-8-openjdk-amd64/jre/',
}
```

### More complex example
```puppet
TODO
```

## Reference

### Classes

#### Public Classes

* `zipkin`: Main class, manages the installation and configuration of Apache Zipkin.

#### Private Classes

* `zipkin::install`: Installs Zipkin jar file
* `zipkin::params`: Default params
* `zipkin::service`: Manage the Zipkin service

### Parameters

#### Zipkin parameters

TODO

## Limitations

* Puppet 4.10.0 or newer

The puppetlabs repositories can be found at: [yum.puppetlabs.com](https://yum.puppetlabs.com) and [apt.puppetlabs.com](https://apt.puppetlabs.com/)

* RedHat/CentOS 6/7
* Ubuntu 14.04/16.04/18.04/19.04
* Debian 9/10

## License:

```
Copyright 2019 Martin Simon

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
