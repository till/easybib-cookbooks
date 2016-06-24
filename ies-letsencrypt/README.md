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

Since we currently install certificates for haproxy via OpsWorks, you have to get the individual values, put them into an SSL app on OpsWorks and re-deploy it.

## Todo

 * setup auto-renew
 * directly use created files
