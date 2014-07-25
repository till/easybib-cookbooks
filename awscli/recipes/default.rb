python_pip "awscli" do
  version node["awscli"]["version"]
  action :install
end
