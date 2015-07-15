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

    def php_repo_url(node = self.node, distribution)
      prefix = 'http://ppa.ezbib.com/mirrors/php'
      if node.fetch('apt', {})['php_mirror_version']
        return prefix + node['apt']['php_mirror_version']
      end
      prefix + '55'
    end

    def ppa_mirror(node = self.node, standard_repo)
      unless use_aptly_mirror?(node)
        return standard_repo
      end
      if (standard_repo == node['apt']['easybib']['ppa'])
        return php_repo_url(node)
      end
      'http://ppa.ezbib.com/mirrors/remote-mirrors'
    end
  end
end
