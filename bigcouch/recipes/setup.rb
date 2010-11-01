include_recipe "bigcouch::prepare"

bigcouch_prefix="/opt/bigcouch"
bigcouch_user="bigcouch"

user "#{bigcouch_user}" do
  comment "Cloudant BigCouch"
  home "#{bigcouch_prefix}"
  action :create
  shell "/usr/sbin/nologin"
end

execute "download bigcouch" do
  command "wget http://github.com/cloudant/bigcouch/tarball/1.0.x -O /tmp/bigcouch-1.0.x.tar.gz"
  not_if "test -f /tmp/bigcouch-1.0.x.tar.gz"
end

execute "extract and fix dir name" do
  cwd "/tmp"
  command "tar zvxf /tmp/bigcouch-1.0.x.tar.gz -C /tmp"
  command "mv /tmp/cloudant-bigcouch-* /tmp/cloudant-bigcouch"
end

execute "compile bigcouch" do
  cwd "/tmp/cloudant-bigcouch"
  command "./configure -p #{bigcouch_prefix} -u #{bigcouch_user}"
  command "make"
end

execute "install bigcouch" do
  cwd "/tmp/cloudant-bigcouch"
  command "make install"
  not_if "test -f #{bigcouch_prefix}/bin/bigcouch"
end

execute "setup init.d" do
  command "ln -s #{bigcouch_prefix}/etc/init.d/bigcouch /etc/init.d/bigcouch"
  not_if "test -L /etc/init.d/bigcouch"
end
