module EasyBib
  module Helpers
    def render_upstream(upstreams, name = '')
      ::EasyBib::Upstream.render_upstream(upstreams, name)
    end

    def fetch_node(node, app, *args)
      ::EasyBib::Config.node(node, app, args)
    end
  end
end
