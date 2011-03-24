# move /var/logs to mount
execute "Move /var/log" do
  command "mv /var/log /mnt"
  not_if "test -h /var/log"
end

# symlink so we don't break any services
link "/var/log" do
  to "/mnt/log"
end
