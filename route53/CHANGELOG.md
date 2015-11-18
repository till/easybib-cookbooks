## v0.5.6
* Put constants in provider namespace
## v0.5.5
* Install aws-sdk-core at compile time
## v0.5.4
* Import aws-sdk-core at beginning of provider
## v0.5.3
* Add throttling error
## v0.5.2
* Add sleep and retry for record update lock
## v0.5.1
* Change delete record in provider to behave gracefully when the record doesn't exist
## v0.5.0
* Change provider to use the AWS SDK v2 gem instead of fog
## v0.4.2
* fix the provider to correctly identify existing records
## v0.4.0
* make "name" the name_attribute of a resource
* depends on xml to support installing nokogiri and fog dependency
## v0.3.8
* allow for nokogiri version to be specified
## v0.3.6
* proper support for serverspec tests
* make sure needed resource defaults are required
* fog require error
## v0.3.5
* enhancements to supported TDD tools
* New Delete action available for record resource
* add aws secret token auth attribute support
* support mock record
* handle trailing dot on record names
* move nokogiri requires so they do not happen before chef_gem
## v0.3.4
* change to attribute names in the build-essential dependency cookbook
## v0.3.3
* support for alias records
* build-essential to correct fog build errors
* install specific fog version by setting attribute
* test-kitchen support and begin enhanced testing frameworks
## v0.3.2
* Add missing "name" attribute to metadata
* install correct libxml2 and libxslt package names for rhel family
* allow multiple MX records (or records in general), passed as array
* Added IAM role support
* Use chef_gem resource for fog install
* correct working record creation and overwrite logic
