gemrc_paths = {
  "root" => "/root",
  "www-data" => "/var/www"
}

home_dir = "/home"

Dir.entries(home_dir).each do |file_name|
  next if file_name =~ /^\.\.?$/
  next unless File.directory?(file_name)
  gemrc_paths[file_name] = "#{home_dir}/#{file_name}"
end

gemrc_paths.each do |username, home_directory|
  cookbook_file "#{home_directory}/.gemrc" do
    mode 0644
    user username
    source "gemrc"
    only_if do
      File.exists?(home_directory)
    end
  end
end
