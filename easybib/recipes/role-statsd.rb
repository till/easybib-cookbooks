#this relies on opsworks' node.js app role!
include_recipe "statsd::configure"
include_recipe "nodejs::configure"