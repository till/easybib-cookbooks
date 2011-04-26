execute "change environment but do not commit" do
  command "sed -i 's,production,playground,g' /srv/www/easybib/current/www/index.php"
end
