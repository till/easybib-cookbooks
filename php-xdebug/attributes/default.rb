default[:xdebug]           = {}
default[:xdebug][:version] = "latest"

default[:xdebug][:config] = {
    "scream"               => 1,
    "remote_enable"        => 1,
    "remote_handler"       => "dbgp",
    "remote_connect_back"  => 1,
    "idekey"               => "XDEBUG_PHPSTORM"
}