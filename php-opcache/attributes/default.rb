default["php-opcache"] = {}
default["php-opcache"]["settings"] = {
  "opcache.memory_consumption" => 500,
  "opcache.interned_strings_buffer" => 8,
  "opcache.max_accelerated_files"=> 100000,
  "opcache.validate_timestamps" => 0,
  "opcache.save_comments" => 1,
  "opcache.fast_shutdown" => 1,
  "opcache.enable_file_override" => 0,
  "opcache.enable_cli" => 0,
  "opcache.optimization_level" => 0,
  "opcache.max_wasted_percentage" => 10
}
