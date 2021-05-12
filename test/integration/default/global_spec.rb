describe package('logrotate') do
  it { should be_installed }
end

describe file('/etc/logrotate.conf') do
  it { should be_a_file }
  its('mode') { should cmp '0644' }
  its('content') { should include 'include /etc/logrotate.d' }
  its('content') { should include '    missingok' }
  its('content') { should include '    monthly' }
end

describe file('/etc/logrotate.d') do
  it { should be_a_directory }
  its('mode') { should cmp '0755' }
end
