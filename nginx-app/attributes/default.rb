default["nginx-app"] = {}
default["nginx-app"][:user] = "www-data"
default["nginx-app"][:group] = "www-data"
default["nginx-app"][:domain] = "scalarium.easybib.com"
default["nginx-app"][:root] = "/var/www/easybib.com/current/www"