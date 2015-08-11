cookbook_file '/etc/profile.d/bib-alias.sh' do
  source 'alias.sh'
  mode   '0755'
end
