execute "Install the latest npm" do
  command "curl http://npmjs.org/install.sh | sh"
  not_if do
    File.exist?("/usr/bin/npm")
  end
end
