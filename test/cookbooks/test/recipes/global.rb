logrotate_global 'logrotate' do
  options %w(create weekly dateext)
  parameters(
    'rotate' => 4
  )
  paths(
    '/var/log/global_log_0' => {
      'missingok' => true,
      'monthly' => true,
      'create' => '0664 root utmp',
      'rotate' => 1,
    },
    '/var/log/global_log_1' => {
      'missingok' => true,
      'monthly' => true,
      'create' => '0600 root utmp',
      'rotate' => 1,
    }
  )
end
