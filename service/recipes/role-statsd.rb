if !is_aws
  include_recipe 'nodejs'
end

include_recipe 'statsd'
