execute "PHP: install pear packages" do
  command "pear channel-update pear.php.net"
  command "pear upgrade-all"
  command "pear install -f Crypt_HMAC2-beta"
  command "pear install -f Net_Gearman-alpha"
  command "pear install -f Services_Amazon_S3-alpha"
end