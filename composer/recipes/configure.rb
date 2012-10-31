# Configure ~/.composer/config.json
node["composer"]["users"].each do |user|

  home = `echo ~#{user}`.strip

  directory "#{home}/.composer" do
    owner user
    mode  "0750"
  end

  template "#{home}/.composer/config.json" do
    owner  user
    source "composer.config.json.erb"
    mode   "0640"
    variables(
      :oauth_key => node["composer"]["oauth_key"]
    )
  end
end
