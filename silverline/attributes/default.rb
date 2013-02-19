if attribute?(:opsworks)
  default[:silverline][:environment] = node[:opsworks][:stack][:name].gsub(/\s/,'')
  default[:silverline][:roles] = node[:opsworks][:instance][:layers]
else
  default[:silverline][:environment] = "production"
  default[:silverline][:roles] = ["default"]
end
# set first 4 bytes of sl_tag_names value and terminate with a colon
sl_tag_names = "env-#{default[:silverline][:environment]}:"
# loop over roles and append characters into sl_tag_names to complete string with all tags
default[:silverline][:roles].each do |role|
  sl_tag_names = sl_tag_names + "role-" + role + ":"
end
# set a real attribute and chop off that last delimiter
default[:silverline][:sl_tag_names] = sl_tag_names.chop!
