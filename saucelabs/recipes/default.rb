package "php-pear"

execute "upgrade: PEAR" do
  command "pear upgrade PEAR"
end

pear_channels = [ "pear.phpunit.de", "components.ez.no", "pear.symfony-project.com", "saucelabs.github.com/pear" ]

pear_channels.each { |channel|

  execute "discover: #{channel}" do
    command "pear channel-discover #{channel}"
  end

  execute "update: #{channel}" do
    command "pear channel-update #{channel}"
  end

}

execute "install PHPUnit_Selenium_SauceOnDemand" do
  command "pear install -a saucelabs/PHPUnit_Selenium_SauceOnDemand"
end

# needs custom json via scalarium
execute "configure: SauceOnDemand" do
  command "sauce configure easybib #{node["saucelabs"]["apikey"]}"
end
