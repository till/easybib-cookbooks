#default[:gearman_manager]        = {}
#default[:gearman_manager][:type] = "pecl"

default["deploy"]["gearmanmanager"]["daemon"]       = "/usr/local/bin/gearman-manager"
default["deploy"]["gearmanmanager"]["real_daemon"]  = "/srv/www/ebim2/current/vendor/GearmanManager/pecl-manager.php"
default["deploy"]["gearmanmanager"]["pid_dir"]      = "/var/run/gearman-manager"
default["deploy"]["gearmanmanager"]["config_file"]  = "/srv/www/ebim2/current/etc/gearman/jango-fett.manager.ini"
default["deploy"]["gearmanmanager"]["worker_class"] = "Ebim2\\Gearman\\Worker\\"

default["nginx-lb"]["role"]    = "lb"
default["nginx-lb"]["cluster"] = "EasyBib Playground"
default["nginx-lb"]["dir"]     = "/etc/nginx"
default["nginx-lb"]["int_ip"]  = "127.0.0.1"
