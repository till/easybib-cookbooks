tmpl   = ["munin-domainview.tmpl", "munin-nodeview.tmpl", "munin-overview.tmpl", "munin-serviceview.tmpl"]
static = ["some.js", "style.css"]

tmpl.each do |template|
  cookbook_file "/etc/munin/templates/#{template}" do
    source "#{template}"
    owner  "munin"
    group  "munin"
    mode   "0644"
    backup false
  end
end

static.each do |asset|
  cookbook_file "/var/www/munin/#{asset}" do
    source "#{asset}"
    owner  "munin"
    group  "munin"
    mode   "0644"
    backup false
  end
end
