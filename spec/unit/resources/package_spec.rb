require 'spec_helper'

describe 'logrotate_package' do
  step_into :logrotate_package
  platform 'centos'

  context 'installs the logrotate package' do
    recipe do
      logrotate_package ''
    end

    describe 'creates a systemd unit file' do
      it { is_expected.to upgrade_package('logrotate') }
    end
  end
end
