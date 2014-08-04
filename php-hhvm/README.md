# php-hhvm

A recipe to install Facebook's HHVM on Ubuntu Precise (12.04).

Currently not included:

 * any kind of web-server setup

## Usage

 * the `apt` community cookbook and the `easybib` cookbook handle repo discovery
 * there is some configuration for the `php.ini` file in `attributes/default.rb`
 * you can install the nightly or debug (dbg) build with:

```json
{
  "php-hhvm": {
    "build": "-dgb"
  }
}
```

## Todo

 * remove dependency on `easybib` cookbook
