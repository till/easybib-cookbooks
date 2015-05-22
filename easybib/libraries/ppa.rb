module EasyBib
  module Ppa
    extend self
    def use_aptly_mirror?(node = self.node)
      is_trusty = (node.fetch('lsb', {})['codename'] == 'trusty')
      enable_trusty_mirror = node.fetch('apt', {})['enable_trusty_mirror']
      is_trusty && enable_trusty_mirror
    end

    def ppa_mirror(node = self.node, standard_repo)
      if use_aptly_mirror?(node)
        return 'http://ppa.ezbib.com/trusty55'
      end
      standard_repo
    end
  end
end
