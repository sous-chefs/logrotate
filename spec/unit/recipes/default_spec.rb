require 'spec_helper'

describe 'logrotate::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs the logrotate package' do
    expect(chef_run).to install_package('logrotate')
  end
end
