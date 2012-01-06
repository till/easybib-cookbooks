d = ['base64', 'async', 'underscore']

d.each do |dep|
  execute "Install #{dep}" do
    command "npm install #{dep}"
  end
end
