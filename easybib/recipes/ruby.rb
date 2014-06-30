gemrc_paths = {
  "root" => "/root",
  "www-data" => "/var/www"
}

gemrc_paths << Dir.entries("/home").select do |f|
  !File.directory? f
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
