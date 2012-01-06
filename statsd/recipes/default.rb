d = ['base64', 'async', 'underscore']

d.each |dep| do
  execute "Install #{dep}" do
    command "npm install #{dep}"
  end
end
