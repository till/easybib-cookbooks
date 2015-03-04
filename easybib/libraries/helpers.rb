module EasyBib
  module Helpers
    def render_upstream(upstreams, name = '')
      ::EasyBib::Upstream.render_upstream(upstreams, name)
    end

    def fetch_node(node, app, *args)
      ::EasyBib::Config.node(node, app, args)
    end

    # split opsworks domain string ("batz bla.domain.com foo.api.example.com") in list of domains
    # ['batz','domain.com','example.com']. Defaults to easybib.com if domains are nil/empty
    def domainstring_to_topleveldomains(domain_name_string)
      domain_names = []
      if !domain_name_string.nil? && !domain_name_string.empty?
        # convert subdomain.easybib.com to easybib\.com for regex below
        domain_name_string.split(' ').each do |domain|
          domain = domain.split('.')
          if domain.length > 1
            domain = domain[-2..-1].join('.')
          else
            domain = domain[0]
          end
          domain_names << domain
        end
      else
        domain_names << 'easybib.com'
      end
      domain_names
    end
  end
end
