# puppet-zipkin

[![Puppet Forge](https://img.shields.io/puppetforge/v/barnumbirr/zipkin.svg)](https://forge.puppetlabs.com/barnumbirr/zipkin)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/barnumbirr/zipkin.svg)](https://forge.puppetlabs.com/barnumbirr/zipkin)

1. [Module Description - What the module does and why it is useful](#description)
2. [Usage - Configuration options and additional functionality](#usage)
    * [Prerequisites](#prerequisites)
    * [Beginning with OpenZipkin](#beginning-with-openzipkin)
    * [More complex example](#more-complex-example)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
        * [Public Classes](#public-classes)
        * [Private Classes](#private-classes)
    * [Parameters](#parameters)
        * [Zipkin Parameters](#zipkin-parameters)
        * [Java JVM parameters](#java-jvm-parameters)
        * [Miscellaneous parameters](#miscellaneous-parameters)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [License](#license)

## Description

This module installs, configures and upgrades [OpenZipkin](https://zipkin.io/) via Puppet. Zipkin is a distributed tracing system.
It helps gather timing data needed to troubleshoot latency problems in microservice architectures. It manages both the collection and lookup of this data.

## Usage

### Prerequisites

To use this module ```Java``` and ```Elasticsearch``` will need to be installed. We recommend managing your Java installation with
[puppetlabs-java](https://forge.puppet.com/puppetlabs/java) and Elasticsearch with [elastic-elasticsearch](https://forge.puppet.com/elastic/elasticsearch).

### Beginning with OpenZipkin

```puppet
class { '::java':
  package   => 'openjdk-11-jre-headless',
  version   => '11.0.5+10-1~deb10u1',
  java_home => '/usr/lib/jvm/java-11-openjdk-amd64/',
}->
class { '::elasticsearch':
}->
class { '::zipkin':
    # JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
    java_home => '/usr/lib/jvm/java-11-openjdk-amd64/',
}
```

### More complex example (using hiera)
```yaml
java::package: openjdk-11-jre-headless
java::version: '11.0.5+10-1~deb10u1'
java::java_home: '/usr/lib/jvm/java-11-openjdk-amd64/'

elasticsearch::version: '6.8.4'
elasticsearch::manage_repo: true
elasticsearch::java_install: false
elasticsearch::restart_on_change: true
elasticsearch::status: 'enabled'
elasticsearch::instances:
  default:
    config:
      'cluster.name': 'zipkin'
      'node.name': 'zipkin'
      'network.host': '127.0.0.1'
    jvm_options:
      - '-Xms2G'
      - '-Xmx4G'
      - '8:-XX:+PrintGCDetails'
      - '8:-XX:GCLogFileSize=64m'
      - '8:-XX:+PrintGCDateStamps'
      - '8:-XX:NumberOfGCLogFiles=32'
      - '8:-XX:+UseGCLogFileRotation'
      - '8:-XX:+PrintTenuringDistribution'
      - '9:-XX:+UseConcMarkSweepGC'
      - '8:-Xloggc:/var/log/elasticsearch/default/gc.log'
      - '9-:-Xlog:gc*,gc+age=trace,safepoint:file=/var/log/elasticsearch/default/gc.log:utctime,pid,tags:filecount=32,filesize=64m'

curator::repository_version: '5'
curator::package_name: 'elasticsearch-curator'

curator::actions::values:
  'delete_zipkin_index':
    entities:
      1:
        action: delete_indices
        description: Delete indices older than 30 days (based on index name)
        options:
          continue_if_exception: True
          disable_action: False
          ignore_empty_list: True
        filters:
          - filtertype: pattern
            kind: prefix
            value: zipkin
          - filtertype: age
            source: name
            direction: older
            timestring: '%Y-%m-%d'
            unit: days
            unit_count: 30

curator::jobs::values:
  'delete_zipkin_index':
    action: 'delete_zipkin_index'
    minute: 0
    hour: 5

zipkin::java_home: "%{hiera('java::java_home')}"
zipkin::version: '2.19.1'
zipkin::use_slim: true
zipkin::user: 'zipkin'
zipkin::group: 'zipkin'
zipkin::install_dir: '/opt/zipkin'
zipkin::jvm_xms: '512m'
zipkin::jvm_xmx: '2048m'
zipkin::java_opts: '-DSTORAGE_TYPE=elasticsearch -DES_HOSTS=http://localhost:9200'
```

## Reference

### Classes

#### Public Classes

* `zipkin`: Main class, manages the installation and configuration of OpenZipkin.

#### Private Classes

* `zipkin::install`: Installs Zipkin jar file
* `zipkin::params`: Modifiy Zipkin configuration
* `zipkin::service`: Manage the Zipkin service

### Parameters

#### Zipkin parameters
```
TODO
```

#### Java JVM parameters
```
TODO
```

#### Miscellaneous parameters
```
TODO
```

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
