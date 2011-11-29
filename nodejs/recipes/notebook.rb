# these are packages we need
packages = ["socket.io", "uglify-js"]

packages.each do |p|
  execute "install #{p}" do
    command "npm install #{p}"
  end
end
