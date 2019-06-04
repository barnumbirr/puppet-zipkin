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

Install and manage [Apache Zipkin](https://zipkin.apache.org/) via Puppet.

## Basic Usage

### Install rinetd with default config

```puppet
class { '::java':
  package => 'openjdk-8-jre',
  version => '8u111-b14-2~bpo8+1',
} ->
class { '::elasticsearch':
} ->
class { 'zipkin':
}
```

### Class Parameters

| Parameter           | Type    | Default             | Description |
| :-------------------| :------ |:------------------- | :---------- |
| allow               | array   | []                  | set allow rules |
| autoupgrade         | boolean | false               | ugrade package automatically if there is a newer version |
| deny                | array   | []                  | set deny rules |
| rules               | array   | []                  | set forwarding rules |
| logfile             | string  | /var/log/rinetd.log | set logfile path |
| logcommon           | boolean | false               | use web-server style logfile format |
| ensure              | string  | present             | latest,present or absent |
| service_manage      | boolean | true                | manage rinetd service state |
| service_restart     | boolean | true                | manage service restart |

## Limitations

This module is currently only written to work on Debian based operating
systems, although it may work on others. The supported Puppet versions are
defined in the [metadata.json](metadata.json)

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
