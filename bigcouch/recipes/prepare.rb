package "erlang-nox"
package "libicu42"
package "libicu-dev"
package "libcurl4-openssl-dev"

execute "import key" do
  command "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 74EE6429"
end

execute "add commonjs ppa" do
  command "echo 'deb http://ppa.launchpad.net/commonjs/ppa/ubuntu karmic main' > /etc/apt/sources.list.d/commonjs.list"
  not_if "test -f /etc/apt/sources.list.d/commonjs.list"
end

execute "update" do
  command "apt-get -y -f -q update"
end

package "libmozjs-1.9.2"
package "libmozjs-1.9.2-dev"

execute "link lib" do
  command "ln -s /usr/lib/libmozjs-1.9.2.so /usr/lib/libmozjs.so"
  not_if "test -L /usr/lib/libmozjs.so"
end
