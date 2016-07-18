# letsencrypt

This recipe installs `certbot-auto` which is used to
acquire SSL certificates from letsencrypt.org.

## Usage

Once `certbot-auto` is available, you can go on a server:

```
$ /etc/init.d/haproxy stop
$ /usr/local/bin/certbot-auto certonly \
--standalone \
-d example.org
```

Certificates end up in `/etc/letsencrypt/live/example.org`.

## Features

 * creates certificate for all domains specified
 * combines/dumps all data into `/etc/nginx/ssl/cert.combined.pem`
 * please note: **adding** another domain is a manual process
