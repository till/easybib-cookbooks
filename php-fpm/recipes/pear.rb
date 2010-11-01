execute "PEAR: enable auto discover for channels" do
  command "pear config-set auto_discover 1"
end

execute "PEAR: update channel" do
  command "pear channel-update pear.php.net"
end

execute "PEAR: upgrade all packages" do
  command "pear upgrade-all"
end

execute "PEAR: install Crypt_HMAC2" do
  command "pear install -f Crypt_HMAC2-beta"
end

execute "PEAR: install Net_Gearman" do 
  command "pear install -f Net_Gearman-alpha"
end

execute "PEAR: install Services_Amazon_S3" do
  command "pear install -f Services_Amazon_S3-alpha"
end

execute "PEAR: install Net_CheckIP2" do
  command "pear install -f Net_CheckIP2-1.0.0RC3"
end
