default['logrotate']['global'] = {
  'weekly' => true,
  'rotate' => 4,
  'create' => '',

  '/var/log/wtmp' => {
    'missingok' => true,
    'monthly' => true,
    'create' => '0664 root utmp',
    'rotate' => 1
  },

  '/var/log/btmp' => {
    'missingok' => true,
    'monthly' => true,
    'create' => '0660 root utmp',
    'rotate' => 1
  }
}
