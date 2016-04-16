require 'spec_helper'

describe 'logrotate::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'installs the logrotate package' do
      expect(chef_run).to install_package('logrotate')
    end

    it 'shoudl create the logrotate.d directory' do
      expect(chef_run).to create_directory('/etc/logrotate.d')
    end

    it 'shoudl not create a cron entry' do
      expect(chef_run).not_to create_cron('logrotate')
    end
  end

  context 'When all attributes are default, on solaris2' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'solaris2', version: 5.11).converge(described_recipe)
    end

    it 'shoudl create a cron entry' do
      expect(chef_run).to create_cron('logrotate').with(
        minute: '35',
        hour: '7',
        command: '/usr/sbin/logrotate /etc/logrotate.conf'
      )
    end
  end
end
