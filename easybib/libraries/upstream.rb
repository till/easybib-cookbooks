module EasyBib
  module Upstream
    def render_upstream(upstreams, name = '')
      name = 'master' if name.empty?

      nginx_upstream = "upstream #{name}_phpfpm {\n"

      upstreams.each do |the_upstream|
        nginx_upstream  << "    server #{the_upstream} weight=100 max_fails=5 fail_timeout=5;\n"
      end

      nginx_upstream << "}\n"

      nginx_upstream
    end
  end
end
