module EasyBibVagrant
  module Helpers
    def generate_cookbook_path(home, node = self.node)
      home = sanitize(home)
      cookbook_path = sanitize(node['easybib_vagrant']['plugin_config']['bib-vagrant']['cookbook_path'])
      "#{home}/#{cookbook_path}"
    end

    private

    def sanitize(str)
      str.strip! || str
    end
  end
end
