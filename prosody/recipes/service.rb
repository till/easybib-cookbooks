service 'prosody' do
  action :nothing
  supports [ :start, :stop, :restart, :reload ]
  reload_command '/usr/bin/prosodyctl reload'
end
