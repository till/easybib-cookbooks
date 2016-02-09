require 'chef/mixin/shell_out'

module Vagrant
  class UserNotFoundError < ArgumentError
  end

  class Plugin
    include Chef::Mixin::ShellOut

    attr_reader :plugin_name, :username, :password

    def windows?
      @is_windows
    end

    def initialize(plugin_name, is_windows, username: nil, password: nil)
      @plugin_name = plugin_name
      @is_windows = is_windows
      @username = username
      @password = password
    end

    # Searches for an installed Vagrant plugin
    # @param name [String] name of the plugin to find
    # @param options [Hash] { username, password, vagrant_home }
    # @return [String] version of installed plugin, e.g. '1.23.34'
    def installed_version
      begin
        list = vagrant_plugin_list
      rescue UserNotFoundError
        # when a user is not found, they can't possibly have any plugins
        return nil
      end
      plugin_line = find_plugin_line(list)
      extract_version_from(plugin_line)
    end

    def install(version = nil, sources = [])
      vagrant_plugin_install = "vagrant plugin install #{plugin_name}"
      vagrant_plugin_install << " --plugin-version #{version}" if version

      sources.each do |source|
        vagrant_plugin_install << " --plugin-source #{source}"
      end

      execute_cli vagrant_plugin_install
    end

    def uninstall
      execute_cli "vagrant plugin uninstall #{plugin_name}"
    end

    private

    def vagrant_plugin_list
      cmd = execute_cli('vagrant plugin list')
      cmd.stdout
    end

    def find_plugin_line(plugin_list_output)
      lines = plugin_list_output.split(/\R/)
      lines.find { |plugin| plugin =~ /#{plugin_name}\s\(/ }
    end

    def extract_version_from(plugin_line)
      semver = /\s\((\d+\.\d+\.\d+)/ # =>  '1.12.34'

      version = semver.match(plugin_line)
      version[1] unless version.nil?
    end

    def execute_cli(command)
      shell_out!(
        command,
        user: username,
        password: password, # required on Windows
        env: { 'VAGRANT_HOME' => vagrant_home }
      )
    end

    def vagrant_home
      user_home_dir = home_dir
      ::File.join(user_home_dir, '.vagrant.d') unless user_home_dir.nil?
    end

    def home_dir
      return Dir.home unless username

      # Dir.home(user) raises ArgumentError: user `user` doesn't exist
      # on Windows so we must workaround for now.
      if windows?
        "C:/Users/#{username}" if Dir.exist?("C:/Users/#{username}")
      else
        begin
          Dir.home(username)
        rescue ArgumentError
          raise UserNotFoundError
        end
      end
    end
  end
end
