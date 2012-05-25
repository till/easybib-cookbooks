default["nginx-app"]                      = {}
default["nginx-app"][:user]               = "www-data"
default["nginx-app"][:group]              = "www-data"
default["nginx-app"][:static_directories] = ["js", "css", "images", "raw"]

# module specific configuration for assets
default["nginx-app"][:js_modules] = {
    "debugger"     => "debugger",
    "notes"        => "notebook",
    "cms"          => "cms",
    "bibanalytics" => "bibanalytics",
    "sharing"      => "sharing",
    "kb"           => "kb",
    "content"      => "content"
}
default["nginx-app"][:img_modules] = {
    "notes"     => "notebook",
    "outline"   => "notebook",
    "paperlink" => "paperlink"
}
default["nginx-app"][:css_modules] = {
    "debugger"     => "debugger",
    "notes"        => "notebook",
    "cms"          => "cms",
    "bibanalytics" => "bibanalytics",
    "sharing"      => "sharing",
    "kb"           => "kb"
}

# Silverline attribs
default[:silverline][:nginx_name] = "nginx"
