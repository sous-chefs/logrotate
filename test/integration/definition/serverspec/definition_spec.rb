require 'serverspec'
set :backend, :exec

describe 'logrotate::default' do
  describe file('/etc/logrotate.d/tomcat-myapp') do
    it { should be_a_file }
    it { should be_mode(644) }
    it do
      should contain '
        "/var/log/tomcat/myapp.log" {
          daily
          rotate 30
          create 644 root adm
        }
      '
    end
  end

  describe file('/etc/logrotate.d/tomcat-myapp-multi-path') do
    it { should be_a_file }
    it { should be_mode(644) }
    it do
      should contain '
        "/var/log/tomcat/myapp.log" "/opt/local/tomcat/catalina.out" {
          daily
          rotate 7
          create 644 root adm
      '
    end
  end

  describe file('/etc/logrotate.d/tomcat-myapp-no-enable') do
    it { should_not be_a_file }
  end

  describe file('/etc/logrotate.d/tomcat-myapp-custom-options') do
    it { should be_a_file }
    it { should be_mode(644) }
    it do
      should contain '
        missingok
        delaycompress
        firstaction
      '
    end
  end

  describe file('/etc/logrotate.d/tomcat-myapp-custom-options-as-string') do
    it { should be_a_file }
    it { should be_mode(644) }
    it do
      should contain '
        missingok
        delaycompress
        firstaction
      '
    end
  end

  describe file('/etc/logrotate.d/tomcat-myapp-custom-template') do
    it { should be_a_file }
    it { should be_mode(644) }
    it { should contain '# This is a custom template!' }
    it do
      should contain '
        missingok
        delaycompress
        firstaction
      '
    end
  end

  describe file('/etc/logrotate.d/tomcat-myapp-sharedscripts') do
    it { should contain 'sharedscripts' }
  end
end
