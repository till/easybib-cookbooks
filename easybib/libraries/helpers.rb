module EasyBib
  module Helpers
    def render_upstream(upstreams, name = '')
      ::EasyBib::Upstream.render_upstream(upstreams, name)
    end

    def fetch_node(node, app, *args)
      ::EasyBib::Config.node(node, app, args)
    end
    
    def get_www_redirect_name(domain_name)
      return domain_name.split(' ').select { |d| d.start_with?('www.') }.map { |d| d[4..-1] }.join(' ')
    end
  end
end
