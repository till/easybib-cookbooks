remote_file "/tmp/install-npm.sh" do
  source "http://npmjs.org/install.sh"
  chmod "0755"
  not_if do
    File.exists?("/usr/bin/npm")
  end
end

execute "Install the latest npm" do
  command "/tmp/install-npm.sh"
  not_if do
    File.exist?("/usr/bin/npm")
  end
end
