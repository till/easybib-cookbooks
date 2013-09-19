["python-avahi", "python-pip"].each do |pkg|
  package pkg
end

execute "update pip" do
  command "pip install --upgrade pip"
end

execute "install python-avahi" do
  command "pip install --force-reinstall #{node["avahi"]["alias"]["package"]}"
end
