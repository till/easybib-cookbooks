# Cookbooks!

 * couchdb (by [Mathias Meyer][meyer]/scalarium)
 * nginx-app (by [Till Klampaeckel][till])
 * php-fpm (by [Till Klampaeckel][till])
 * unfuddle-ssl-fix (by [Till Klampaeckel][till])

## Override scalarium

 * deploy
 * haproxy

[meyer]: http://www.paperplanes.de/
[till]: http://till.klampaeckel.de/blog/

# Todo Till

 * create gearman role
 * create redis role

# Todo Scalarium

 * PRIO 1: Cookbooks werden nicht gesynct (Fehler im Setup, man muss "site-cookbooks" auf der Instanz loeschen)
 * PRIO 1: Unter dem Account weitere user (sozusagen "sub accounts")
 * PRIO 1: Elastic IP anzeigen wenn vergeben (nicht standard public IP)
 * PRIO 1: Deploy immer automatisch ausfuehren
 * PRIO 2: Private Keys: nachtraeglich ausfuellen
 * PRIO 3: Eine "availability zone" (z.B. East1a) als "default"
 * PRIO 3: Die Recipes anzeigen die bei den vordefinierten Rollen ausgefuehrt werden
 * PRIO 4: Eventuell auch die Standard-Recipes zum Auswaehlen irgendwo bereitstellen
 * PRIO 4: Instanzdetails syncen - auch wenn nicht gestartet ueber Scalarium