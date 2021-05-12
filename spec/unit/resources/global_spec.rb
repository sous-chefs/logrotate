require 'spec_helper'

describe 'logrotate_global' do
  step_into :logrotate_global
  platform 'centos'

  recipe do
    logrotate_global 'logrotate' do
      options %w(create weekly)
      parameters(
        'rotate' => 4
      )
      paths(
        '/var/log/wtmp' => {
          'missingok' => true,
          'monthly' => true,
          'create' => '0664 root utmp',
          'rotate' => 1,
        },
        '/var/log/btmp' => {
          'missingok' => true,
          'monthly' => true,
          'create' => '0600 root utmp',
          'rotate' => 1,
        }
      )
    end
  end

  it 'writes the configuration template' do
    is_expected.to render_file('/etc/logrotate.conf')
      .with_content(/rotate 4/)
      .with_content(/weekly/)
      .with_content(%r{\/var\/log\/wtmp \{})
      .with_content(/    create 0664 root utmp/)
      .with_content(/    missingok/)
      .with_content(/    monthly/)
  end
end
