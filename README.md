# puppet-zipkin

[![Puppet Forge](https://img.shields.io/puppetforge/v/barnumbirr/zipkin.svg)](https://forge.puppetlabs.com/barnumbirr/zipkin)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/barnumbirr/zipkin.svg)](https://forge.puppetlabs.com/barnumbirr/zipkin)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/barnumbirr/zipkin.svg)](https://forge.puppetlabs.com/barnumbirr/zipkin)

1. [Module Description - What the module does and why it is useful](#description)
2. [Usage - Configuration options and additional functionality](#usage)
    * [Prerequisites](#prerequisites)
    * [Beginning with Apache Zipkin](#beginning-with-apache-zipkin)
    * [More complex example](#more-complex-example)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
        * [Public Classes](#public-classes)
        * [Private Classes](#private-classes)
    * [Classes](#classes)
        * [Zipkin Parameters](#zipkin-parameters)
        * [Java JVM parameters](#java-jvm-parameters)
        * [Miscellaneous parameters](#miscellaneous-parameters)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [License](#license)

## Description

This module installs, configures and upgrades [Apache Zipkin](https://zipkin.apache.org/) via Puppet. Zipkin is a distributed tracing system.
It helps gather timing data needed to troubleshoot latency problems in microservice architectures. It manages both the collection and lookup of this data.

## Usage

### Prerequisites

To use this module ```Java``` and ```Elasticsearch``` will need to be installed. We recommend managing your Java installation with
[puppetlabs-java](https://forge.puppet.com/puppetlabs/java) and Elasticsearch with [elastic-elasticsearch](https://forge.puppet.com/elastic/elasticsearch).

### Beginning with Apache Zipkin

```puppet
class { '::java':
  package => 'openjdk-8-jre',
  version => '8u111-b14-2~bpo8+1',
}->
class { '::elasticsearch':
}->
class { '::zipkin':
    # JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
    javahome => '/usr/lib/jvm/java-8-openjdk-amd64/jre',
}
```

### More complex example (using hiera)
```yaml
java::package: openjdk-8-jre-headless
java::version: '8u212-b03-2~deb9u1'

# Elasticsearch 6
elasticsearch::version: '6.8.1'
elasticsearch::manage_repo: true
elasticsearch::java_install: false
elasticsearch::restart_on_change: true
elasticsearch::instances:
  default:
    config:
      'cluster.name': 'zipkin'
      'node.name': 'zipkin'
      'network.host': '127.0.0.1'

zipkin::javahome: '/usr/lib/jvm/java-8-openjdk-amd64/jre'
zipkin::version: '2.14.0'
zipkin::user: 'zipkin'
zipkin::group: 'zipkin'
zipkin::installdir: '/opt/zipkin'
zipkin::jvm_xms: '512m'
zipkin::jvm_xmx: '2048m'
zipkin::java_opts: '-DSTORAGE_TYPE=elasticsearch -DES_HOSTS=http://localhost:9200'
```

## Reference

### Classes

#### Public Classes

* `zipkin`: Main class, manages the installation and configuration of Apache Zipkin.

#### Private Classes

* `zipkin::install`: Installs Zipkin jar file
* `zipkin::params`: Modifiy Zipkin configuration
* `zipkin::service`: Manage the Zipkin service

### Parameters

#### Zipkin parameters

TODO

#### Java JVM parameters

TODO

#### Miscellaneous parameters

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
