module EasyBib
  module Ppa
    extend self
    def use_aptly_mirror?(node = self.node)
      distribution = node.fetch('lsb', {})['codename']
      enable_aptly_mirror?(node) && is_known_distribution?(distribution)
    end

    def enable_aptly_mirror?(node = self.node)
      enable_ppa_mirror = node.fetch('apt', {}).fetch('enable_ppa_mirror', false)
      unless enable_ppa_mirror
        # enable trusty mirror is an old param, this check is for backwards compat
        enable_ppa_mirror = node.fetch('apt', {}).fetch('enable_trusty_mirror', false)
      end
      enable_ppa_mirror
    end

    def is_known_distribution?(distribution)
      known_distributions = ['trusty']
      known_distributions.include?(distribution)
    end

    def repo_url(node = self.node, distribution)
      prefix = 'http://ppa.ezbib.com/' + distribution
      if node.fetch('apt', {})['ppa_mirror_version']
        return prefix + node['apt']['ppa_mirror_version']
      end
      prefix + '55'
    end

    def ppa_mirror(node = self.node, standard_repo)
      unless use_aptly_mirror?(node)
        return standard_repo
      end
      distribution = node.fetch('lsb', {})['codename']
      repo_url(node, distribution)
    end
  end
end
