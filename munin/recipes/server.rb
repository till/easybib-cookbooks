package "munin"

if File.directory?("/etc/apache2") 
  include_recipe "munin::apache2"
end
