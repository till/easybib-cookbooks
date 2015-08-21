# php-opcache

 * `php-opcache::default`: installs the opcache extension
 * `php-opcache::configure`: configures the extension for php

## Configuration

Configuration mostly refers to attributes in this cookbook.

Whatever is in `node['php-opcache']['settings']` equals to the available settings
for the OPcache extension and can be changed/extended/etc..

More info: http://docs.php.net/manual/en/opcache.configuration.php

We do not track/list all of them there. Whatever is not "added" falls by back
to the default.

## Operation

 1. calculate the number of scripts to cache
   * rough number of files in your code-base * 3 (or 4)
   * in `opcache_get_status()` look for `max_cached_keys`
   * configuration: `max_accelerated_files`
   * monitor:
     * `hash_restarts` (triggered when this number is exceeded)
     * ideally `num_cached_scripts` and `num_cached_keys` are pretty much equal
       * e.g. `composer dump-autoload --optimize` helps
 2. memory you can spare, or how big is your code base:
   * in `opcache_get_status()` look for `used_memory` and `free_memory`
   * configuration: `memory_consumption`
   * monitor: `oom_restarts`
 3. by default `validate_timestamps` is off
   * this is not helpful for development environments
   * for production priming, check out: https://github.com/easybiblabs/opcache-primer
