module PhpFpm
  module Helper
    def get_upstream_from_pools(pools, socket_dir)
      php_upstream = []
      pools.each do |pool_name|
        php_upstream << "unix:#{socket_dir}/#{pool_name}"
      end

      php_upstream
    end
  end
end

Chef::Provider.send(:include, ::PhpFpm::Helper)
Chef::Recipe.send(:include, ::PhpFpm::Helper)
Chef::Resource.send(:include, ::PhpFpm::Helper)
