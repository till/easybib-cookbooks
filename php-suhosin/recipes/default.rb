include_recipe "apt::ppa"
include_recipe "apt::easybib"

check_cmd = Mixlib::ShellOut.new("dpkg -s php5-easybib-suhosin")
check_cmd.run_command

package "php5-easybib-suhosin" do
  only_if do
    check_cmd.exitstatus == 0
  end
end

include_recipe "php-suhosin::configure"
