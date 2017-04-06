execute 'apt-get-update' do
  command 'apt-get update; touch /var/lib/apt/periodic/update-success-stamp'
  ignore_failure true
  not_if { ::File.exist?('/var/lib/apt/periodic/update-success-stamp') }
end
