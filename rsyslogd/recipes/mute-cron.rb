cookbook_file '/etc/rsyslog.d/10-mute.conf' do
  source '10-mute.conf'
  mode 0644
end
