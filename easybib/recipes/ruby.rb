gemrc_paths = {
  "root" => "/root",
  "www-data" => "/var/www"
}

home_dir = "/home"

Dir.entries(home_dir).each do |fileName|
  next if fileName =~ /^\.\.?$/
  next unless File.directory?(fileName)
  gemrc_paths["#{fileName}"] = "#{home_dir}/#{fileName}"
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
