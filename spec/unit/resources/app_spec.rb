require 'spec_helper'

describe 'logrotate_global' do
  step_into :logrotate_resources
  platform 'centos'

  recipe do
    include_recipe 'test::app'
  end

  context 'tomcat-myapp' do
    it 'creates appropriate logrotate config' do
      expect(chef_run).to enable_logrotate_app('tomcat-myapp').with(
        create: '644 root adm',
        frequency: 'daily',
        path: '"/var/log/tomcat/myapp.log"',
        rotate: 30
      )
    end
  end

  context 'tomcat-myapp-multi-path' do
    it 'creates appropriate logrotate config' do
      expect(chef_run).to enable_logrotate_app('tomcat-myapp-multi-path').with(
        create: '644 root adm',
        frequency: 'daily',
        path: '"/opt/local/tomcat/catalina.out" "/var/log/tomcat/myapp-multi-path.log"',
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
        path: '"/var/log/tomcat/myapp-custom-options.log"',
        rotate: 30,
        options: %w(delaycompress missingok),
        firstaction: 'echo "hi"'
      )
    end
  end

  context 'tomcat-myapp-sharedscripts' do
    it 'creates appropriate logrotate config' do
      expect(chef_run).to enable_logrotate_app('tomcat-myapp-sharedscripts').with(
        options: %w(compress copytruncate delaycompress missingok notifempty sharedscripts),
        path: '"/var/log/tomcat/myapp-sharedscripts.log"'
      )
    end
  end
end
