require 'spec_helper'

describe 'test::resources' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  context 'tomcat-myapp' do
    it 'creates appropriate logrotate config' do
      expect(chef_run).to enable_logrotate_app('tomcat-myapp').with(
        create: '644 root adm',
        frequency: 'daily',
        path: '/var/log/tomcat/myapp.log',
        rotate: 30
      )
    end
  end

  context 'tomcat-myapp-multi-path' do
    it 'creates appropriate logrotate config' do
      expect(chef_run).to enable_logrotate_app('tomcat-myapp-multi-path').with(
        create: '644 root adm',
        frequency: 'daily',
        path: %w(/var/log/tomcat/myapp.log /opt/local/tomcat/catalina.out),
        rotate: 7
      )
    end
  end

  context 'tomcat-myapp-no-enable' do
    it 'does not create appropriate logrotate config' do
      expect(chef_run).not_to enable_logrotate_app('tomcat-myapp-no-enable')
    end
  end

  context 'tomcat-myapp-custom-options' do
    it 'creates appropriate logrotate config' do
      expect(chef_run).to enable_logrotate_app('tomcat-myapp-custom-options').with(
        create: '644 root adm',
        frequency: 'daily',
        path: '/var/log/tomcat/myapp.log',
        rotate: 30,
        options: %w(missingok delaycompress),
        firstaction: 'echo "hi"'
      )
    end
  end

  context 'tomcat-myapp-sharedscripts' do
    it 'creates appropriate logrotate config' do
      expect(chef_run).to enable_logrotate_app('tomcat-myapp-sharedscripts').with(
        sharedscripts: true,
        options: %w(missingok compress delaycompress copytruncate notifempty),
        path: '/var/log/tomcat/myapp.log'
      )
    end
  end
end
