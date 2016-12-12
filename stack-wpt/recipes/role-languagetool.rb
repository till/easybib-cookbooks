include_recipe 'java'
lt_conf = node['stack-wpt']['languagetool']

ark 'languagetool' do
  url "https://languagetool.org/download/LanguageTool-#{lt_conf['version']}.zip"
  version lt_conf['version']
  home_dir lt_conf['path']
  owner node['nginx-app']['user']
  group node['nginx-app']['group']
  checksum lt_conf['checksum']
end
