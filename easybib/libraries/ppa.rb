module EasyBib
  module Ppa
    extend self
    def use_aptly_mirror?(node = self.node)
      distribution = node.fetch('lsb', {})['codename']
      enable_aptly_mirror?(node) && is_known_distribution?(distribution)
    end

    def enable_aptly_mirror?(node = self.node)
      enable_ppa_mirror = node.fetch('easybib', {}).fetch('enable_ppa_mirror', false)
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

    def php_launchpad_repo_url(node = self.node)
      prefix = 'ppa:easybib/php'
      if node.fetch('easybib', {})['php_mirror_version']
        return prefix + node['easybib']['php_mirror_version']
      end
      prefix + '55'
    end

    def php_mirror_repo_url(node = self.node)
      prefix = 'http://ppa.ezbib.com/mirrors/php'
      prefix + node['easybib']['php_mirror_version']
    end

    def ppa_mirror(node = self.node, standard_repo = 'easybib-php-ppa')
      if (standard_repo == 'easybib-php-ppa')
        if use_aptly_mirror?(node)
          return php_mirror_repo_url(node)
        else
          return php_launchpad_repo_url(node)
        end
      end

      unless use_aptly_mirror?(node)
        return standard_repo
      end

      'http://ppa.ezbib.com/mirrors/remote-mirrors'
    end
  end
end
