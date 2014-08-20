include_recipe "aptly::repo"

package "php5-easybib-suhosin" do
  only_if do
    check_cmd = Mixlib::ShellOut.new("apt-get install -s php5-easybib-suhosin")
    check_cmd.run_command
    check_cmd.exitstatus == 0
  end
end

include_recipe "php-suhosin::configure"
