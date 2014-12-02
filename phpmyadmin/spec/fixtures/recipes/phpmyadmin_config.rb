phpmyadmin_config '/some/dir'

srv = [
  {
    'cookie' => true,
    'something' => false,
    'nullvalue' => nil,
    'conf' => 'thing'
  },
  {
    'secondconf' => 'thing'
  }
]

phpmyadmin_config '/some/other/dir' do
  servers srv
end
