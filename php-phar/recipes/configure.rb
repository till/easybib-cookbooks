php_pecl "phar" do
  config_directives {
    "detect_unicode" => "Off",
    "phar.readonly" => "Off",
    "phar.require_hash" => "Off"
  }
  action :setup
end