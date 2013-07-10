case node[:lsb][:codename]
when 'lucid'
  include_recipe "apt::ppa"
  include_recipe "apt::easybib"
  node[:gearmand][:name] = 'gearmand-easybib'
when 'precise'
  node[:gearmand][:name] = 'gearman-job-server'
end

package node[:gearmand][:name]

include_recipe "gearmand::configure"
