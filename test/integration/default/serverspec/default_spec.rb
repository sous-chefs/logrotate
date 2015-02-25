require 'serverspec'
set :backend, :exec

describe 'logrotate::default' do
  describe package('logrotate') do
    it { should be_installed }
  end
end
