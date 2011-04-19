tmpl   = ["munin-domainview.tmpl", "munin-nodeview.tmpl", "munin-overview.tmpl", "munin-serviceview.tmpl"]
static = ["some.js", "style.css"]

tmplDir = '/etc/munin/templates'

tmpl.each do |template|
  cookbook_file "#{tmplDir}/#{template}" do
    source "#{template}"
    owner  node[:munin][:user]
    group  node[:munin][:group]
    mode   "0644"
    backup false
  end
end

static.each do |asset|
  cookbook_file "#{node[:munin][:www_dir]}/#{asset}" do
    source "#{asset}"
    owner  node[:munin][:user]
    group  node[:munin][:group]
    mode   "0644"
    backup false
  end
end
