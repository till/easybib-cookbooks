package 'postfix'
include_recipe 'postfix::mailname'
include_recipe 'postfix::aliases'
include_recipe 'postfix::relay'
