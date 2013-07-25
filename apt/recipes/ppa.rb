case node["platform"]
when "ubuntu"
  package "python-software-properties"
when "debian"
  directory "/usr/local/bin/" do
    recursive true
    action    :create
  end
  cookbook_file "/usr/local/bin/add-apt-repository.sh" do
    source "add-apt-repository.sh"
    mode   0755
  end
end
