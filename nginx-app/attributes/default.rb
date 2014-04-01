default["nginx-app"]                       = {}
default["nginx-app"]["user"]               = "www-data"
default["nginx-app"]["group"]              = "www-data"
default["nginx-app"]["static_directories"] = ["js", "css", "images", "raw"]
default["nginx-app"]["config_dir"]         = "/etc/nginx"
default["nginx-app"]["conf_file"]          = "easybib.com.conf.erb"

default["nginx-app"]["ppa"] = "ppa:easybib/remote-mirrors"

default["nginx-app"]["extras"] = ""

default["nginx-app"]["default_router"] = "index.php"
default["nginx-app"]["health_check"] = "health_check.php"

default["nginx-app"]["contact_url"] = "http://easybib.com/company/contact"

default["nginx-app"]["vagrant"] = {}
default["nginx-app"]["vagrant"]["deploy_dir"] = "/vagrant_data/web/"

# module specific configuration for assets
default["nginx-app"]["js_modules"] = {
    "debugger"        => "debugger",
    "notes"           => "notebook",
    "cms"             => "cms",
    "bibanalytics"    => "bibanalytics",
    "sharing"         => "sharing",
    "kb"              => "kb",
    "infolit"         => "infolit",
    "schoolanalytics" => "schoolanalytics",
    "students"        => "students",
    "pearson"         => "pearson",
    "folders"         => "folders"
}
default["nginx-app"]["img_modules"] = {
    "notes"     => "notebook",
    "outline"   => "notebook",
    "paperlink" => "paperlink",
    "infolit"   => "infolit",
    "braintree" => "braintree",
    "pearson"   => "pearson",
    "folders"   => "folders"
}
default["nginx-app"]["css_modules"] = {
    "debugger"        => "debugger",
    "notes"           => "notebook",
    "cms"             => "cms",
    "bibanalytics"    => "bibanalytics",
    "sharing"         => "sharing",
    "kb"              => "kb",
    "infolit"         => "infolit",
    "schoolanalytics" => "schoolanalytics",
    "braintree"       => "braintree",
    "pearson"         => "pearson",
    "folders"         => "folders"
}

# app config:
# default["nginx-app"]["example-app"] = {}
# default["nginx-app"]["example-app"]["routes_enabled"] = []
# default["nginx-app"]["example-app"]["routes_denied"] = []
# default["nginx-app"]["example-app"]["health_check"] = "health_check.php"
