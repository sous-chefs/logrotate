require 'serverspec'
set :backend, :exec

describe 'logrotate::default' do
  describe file('/etc/logrotate.conf') do
    it { should be_a_file }
    it { should be_mode(644) }
    it { should contain('include /etc/logrotate.d') }
  end

  describe file('/etc/logrotate.d') do
    it { should be_a_directory }
    it { should be_mode(755) }
  end
end
