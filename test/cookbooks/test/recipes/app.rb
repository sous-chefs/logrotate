logrotate_app 'tomcat-myapp' do
  path      '/var/log/tomcat/myapp.log'
  frequency 'daily'
  rotate    30
  create    '644 root adm'
end

logrotate_app 'tomcat-myapp-multi-path' do
  path      %w(/var/log/tomcat/myapp-multi-path.log /opt/local/tomcat/catalina.out)
  frequency 'daily'
  create    '644 root adm'
  rotate    7
end

logrotate_app 'tomcat-myapp-no-enable' do
  path      '/var/log/tomcat/myapp-no-enable.log'
  frequency 'daily'
  rotate    30
  action :disable
end

logrotate_app 'tomcat-myapp-custom-options' do
  path        '/var/log/tomcat/myapp-custom-options.log'
  options     %w(missingok delaycompress)
  frequency   'daily'
  rotate      30
  create      '644 root adm'
  firstaction 'echo "hi"'
end

logrotate_app 'tomcat-myapp-custom-options-as-string' do
  path        '/var/log/tomcat/myapp-custom-options-as-string.log'
  options     'missingok delaycompress'
  frequency   'daily'
  rotate      30
  create      '644 root adm'
  firstaction 'echo "hi"'
end

logrotate_app 'tomcat-myapp-custom-template' do
  path        '/var/log/tomcat/myapp-custom-template.log'
  cookbook    'test'
  options     'missingok delaycompress'
  frequency   'daily'
  rotate      30
  create      '644 root adm'
  firstaction 'echo "hi"'
end

logrotate_app 'tomcat-myapp-sharedscripts' do
  path '/var/log/tomcat/myapp-sharedscripts.log'
  options 'missingok compress delaycompress copytruncate notifempty sharedscripts'
end

logrotate_app 'tomcat-myapp-multi-script' do
  path '/var/log/tomcat/myapp-multi-script.log'
  postrotate [
    '/bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true',
    '/bin/kill -HUP `cat /var/run/rsyslogd.pid 2> /dev/null` 2> /dev/null || true',
  ]
end
