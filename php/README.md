# php_pear

 * actions: `:install`, `:install_if_missing`, `:uninstall`, `:upgrade`
 * attributes: `channel`, `force`, `version`

## Example

    php_pear "EasyBib_Form_Decorator" do
      action  :install_if_missing
      channel "easybib.github.com/pear"
      force   true
      version "0.3.2"
    end

# php_pecl

This resource is a heavy WIP since it contains a couple hard-coded paths, which may or may not be what they are on your system.

 * actions: `:install`, `:setup`
 * `:install`: runs `pecl install foo`
 * `:setup`: creates an `extension.ini`

## Example

    php_pecl "memache" do
      action [:install, :setup]
    end


# php-opcache

 * `php::module-opcache`: configures and installs the extension for php

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