# Cookbooks!

 * easybib-base (by [Till Klampaeckel][till])
 * couchdb (by [Mathias Meyer][meyer]/scalarium)
 * gearman (by [Till Klampaeckel][till])
 * nginx-app (by [Till Klampaeckel][till])
 * php-fpm (by [Till Klampaeckel][till])
 * redis (by [Mathias Meyer][meyer]/scalarium)
 * unfuddle-ssl-fix (by [Till Klampaeckel][till])

## Override scalarium

 * deploy
 * haproxy

[meyer]: http://www.paperplanes.de/
[till]: http://till.klampaeckel.de/blog/

# Todo Till

 * create redis role
 * logrotate:
   * gearman
   * nginx
   * php-fpm

# Todo Scalarium

 * PRIO 1: Unter dem Account weitere user (sozusagen "sub accounts")
 * PRIO 3: Eine "availability zone" (z.B. East1a) als "default"
 * PRIO 3: Die Recipes anzeigen die bei den vordefinierten Rollen ausgefuehrt werden
 * PRIO 4: Eventuell auch die Standard-Recipes zum Auswaehlen irgendwo bereitstellen
 * PRIO 4: Instanzdetails syncen - auch wenn nicht gestartet ueber Scalarium