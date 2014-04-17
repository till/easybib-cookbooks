
# supply our init-script with `>/dev/null` removed in test_nginx_config
cookbook_file "/etc/init.d/nginx" do
  source "nginx"
  mode   "0755"
  owner  "root"
  only_if do
    ::EasyBib.is_aws(node)
  end
end
