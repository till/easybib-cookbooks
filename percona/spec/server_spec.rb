require 'chefspec'

describe 'percona::server' do
  let (:chef_run) do
    ChefSpec::Runner.new.converge('percona::server')
  end

  it 'it installs the server and the client' do
    expect(chef_run).to install_package('percona-server-common-5.5')
    expect(chef_run).to install_package('percona-server-client-5.5')

    expect(chef_run).to install_package('percona-server-server-5.5')

    expect(chef_run).to render_file('/etc/mysql/conf.d/vagrant.cnf')
      .with_content(
        include('wait_timeout')
      )
  end

end
