commands = [
  "wget -O - http://download.newrelic.com/548C16BF.gpg | apt-key add -",
  "echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' > /etc/apt/sources.list.d/newrelic.list",
  "apt-get update"
]

commands.each do |cmd|
  execute cmd
end
