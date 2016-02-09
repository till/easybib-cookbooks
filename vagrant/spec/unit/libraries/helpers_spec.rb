require 'spec_helper'
require_relative '../../../libraries/helpers'

RSpec.describe Vagrant::Helpers do
  let(:my_recipe) { Class.new { extend Vagrant::Helpers } }
  let(:checksums) do
    [
      '3d2e680cc206ac1d480726052e42e193eabce56ed65fc79b91bc85e4c7d2deb8  vagrant_1.7.4.dmg',
      'a1ca7d99f162e001c826452a724341f421adfaef3e1366ee504b73ad19e3574f  vagrant_1.7.4.msi',
      '050411ba8b36e322c4ce32990d2539e73a87fabd932f7397d2621986084eda6a  vagrant_1.7.4_i686.deb',
      'f83ea56f8d1a37f3fdf24dd4d14bf8d15545ed0e39b4c1c5d4055f3de6eb202d  vagrant_1.7.4_i686.rpm',
      'dcd2c2b5d7ae2183d82b8b363979901474ba8d2006410576ada89d7fa7668336  vagrant_1.7.4_x86_64.deb',
      'b0a09f6e6f9fc17b01373ff54d1f5b0dc844394886109ef407a5f1bcfdd4e304  vagrant_1.7.4_x86_64.rpm'
    ]
  end

  it 'returns the correct Vagrant package URL' do
    allow(my_recipe).to receive(:package_version).and_return('1.7.4')
    allow(my_recipe).to receive(:package_extension).and_return('.dmg')

    expect(my_recipe.vagrant_package_uri).to eq 'https://releases.hashicorp.com/vagrant/1.7.4/vagrant_1.7.4.dmg'
  end

  it 'returns the correct SHA256 checksum for the mac_os_x package' do
    allow(my_recipe).to receive(:package_version).and_return('1.7.4')
    allow(my_recipe).to receive(:package_extension).and_return('.dmg')
    allow(my_recipe).to receive(:fetch_platform_checksums_for_version).and_return(checksums)

    expect(my_recipe.vagrant_sha256sum).to eq '3d2e680cc206ac1d480726052e42e193eabce56ed65fc79b91bc85e4c7d2deb8'
  end

  it 'returns the correct SHA256 checksum for the RHEL package' do
    allow(my_recipe).to receive(:package_version).and_return('1.7.4')
    allow(my_recipe).to receive(:package_extension).and_return('_x86_64.rpm')
    allow(my_recipe).to receive(:fetch_platform_checksums_for_version).and_return(checksums)

    expect(my_recipe.vagrant_sha256sum).to eq 'b0a09f6e6f9fc17b01373ff54d1f5b0dc844394886109ef407a5f1bcfdd4e304'
  end
end
