pecl-manager Cookbook
============
This cookbook includes a service definition for pecl-manager as a recipe, and a provider to add and generate
the relevant ```/etc/init.d/pecl-manager```.

Related: https://github.com/brianlmoon/GearmanManager

Requirements
------------
This cookbook requires Chef 11.0.0 or later.

### Platform

* Ubuntu 12.04

May work with or without modification on other Debian derivatives.

-------
### service
This recipe only includes the service defintion for ```pecl-manager```.

Resources/Providers
-------------------
### `script`
This LWRP provides an easy way to generate a ```/etc/init.d/pecl-manager``` init script. It includes configuration
from two different locations, and exports them in the script as environment variables:
- From the node configuration: If you supply the parameter ```envvar_json_source```, all key/value-pairs under
```node[envvar_json_source]``` will be exported. See ```easybib/libraries/easybib.rb```, function ```get_env_for_shell```
for implementation details
- From a file in the source: The file supplied with the parameter ```envvar_file```.

#### Easybib-Deploy
This LWRP is included in easybib\_deploy and executed when the envvar\_file exists.

#### Environment Variables
There are several environment variables used to configure the init script. All of them are provided with a default
setting - then first the JSON variables, then the variables from ```envvar_file``` are set. You can therefore
override all default variables with your custom settings.

Default Variables:
```
 #Path to application root directory, set by the cookbooks
APPDIR=#variable
 # The pecl_manager file to start
DAEMON=${APPDIR}/bin/pecl_manager
 # The directory the pidfile resides at
PIDDIR=/var/run/gearman
 # Name and path to the pid file
PIDFILE=${PIDDIR}/manager.pid
 # Name and path of the logfile. This also can be 'syslog'
LOGFILE=/var/log/gearman-manager.log
 # The user to run as
GEARMANUSER="www-data"
 # Additional parameters to $DAEMON:
PARAMS="-w /dev/null -vvv"
```

#### Actions
- :create: creates the the file, registers and restarts the service.

#### Attribute Parameters
- dir (required): The root directory for the script
- envvar_file (required): The file to include for environment variables (see above)
- envvar_json: The json key to import environment variables from (see above)

#### Examples

```
pecl\_manager\_script "Setting up Pecl Manager" do
  dir                  "/var/www"
  envvar\_file         "/var/www/deploy/pecl\_manager\_env"
  envvar\_json\_source "defaultsettings"
end
```

License & Authors
-----------------
- Author:: Till Klampaeckel (till@php.net)
- Author:: Florian Holzhauer (fh-easybib@fholzhauer.de)

```text
Copyright (c) 2014 Till Klampaeckel, Florian Holzhauer, ImagineEasy Solutions LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.
```
