#default[:gearman_manager]        = {}
#default[:gearman_manager][:type] = "pecl"

default["gearmanmanager"]["daemon"]       = "/usr/local/bin/gearman-manager"
default["gearmanmanager"]["real_daemon"]  = "/srv/www/ebim2/current/vendor/GearmanManager/pecl-manager.php"
default["gearmanmanager"]["pid_dir"]      = "/var/run/gearman-manager"
default["gearmanmanager"]["config_file"]  = "/srv/www/ebim2/current/etc/gearman/jango-fett.manager.ini"
default["gearmanmanager"]["worker_class"] = "Ebim2\\Gearman\\Worker\\"

default["ssl-deploy"] = {}
default["ssl-deploy"]["directory"] = "/etc/nginx/ssl"

default["s3-syncer"]["path"] = "/mnt/srv/www/s3-syncer/"
default["s3-syncer"]["source"] = "https://github.com/easybiblabs/s3-syncer/archive/master.tar.gz"

default["bibcd"]["apps"] = {}
