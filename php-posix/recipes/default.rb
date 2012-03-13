if node[:lsb][:codename] != 'lucid'
  raise "This works with lucid only!"
end

cookbook_file "/usr/local/lib/php/extensions/no-debug-non-zts-20090626/posix.so" do
  source "posix.so"
  owner  "root"
  group  "root"
  mode   "0644"
end

execute "create .ini" do
  command 'echo "extension=posix.so" > /usr/local/etc/php/posix.ini'
end
