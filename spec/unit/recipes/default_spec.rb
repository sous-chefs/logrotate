require 'spec_helper'

describe 'logrotate::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'installs the logrotate package' do
    expect(chef_run).to upgrade_package('logrotate')
  end
end
