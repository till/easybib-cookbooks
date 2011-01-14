# move /var/logs to mount
execute "Move /var/logs" do
  command "mv /var/logs /mnt"
  not_if "test -h /var/logs"
end

# symlink so we don't break any services
link "/var/logs" do
  to "/mnt/logs"
end
