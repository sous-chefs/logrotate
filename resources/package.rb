#
# Cookbook:: logrotate
# Resource:: app
#
# Copyright:: 2009-2019, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

unified_mode true if respond_to? :unified_mode

property :packages, [String, Array],
          default: 'logrotate'

property :cookbook, String,
         default: 'sev1_logrotate'

default_action :install
allowed_actions %i[install remove]

include ::Logrotate::Cookbook::LogrotateHelpers

action_class do

  def do_windows_install

    powershell_script 'install_nuget_provider' do
      code 'Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force'
      # windows ---- i hate you so much.
      action :run
      not_if 'Get-PackageProvider -Name NuGet'
    end

    powershell_package_source 'PowershellGallery' do
      source_location 'https://www.powershellgallery.com/api/v2'
    end


    begin
      # there's a bug in cinc 17.10.0, fixed in > 17.10.0 but as of this writing
      # 17.10.0 is the latest version of cinc client available.
      #
      # The package installs fine, but the bug causes a problem that makes chef think
      # the powershell command failed. begin/rescue here hacks around the problem.
      # powershell_package 'Log-Rotate' do
      #   skip_publisher_check true
      #   action :install
      # end
    rescue NoMethodError => e
      msg = <<EOF
        Chef just did an amber heard on the bed:
        #{e.message}
        Going to pretend it didn't happen.
EOF
      Chef::Log.warn(msg)
    end

    directory lr_basepath('/bin') do
      action :create
      recursive true
    end

    template ::File.join(lr_basepath('/bin'), 'run.ps1') do
      cookbook new_resource.cookbook
      source 'run.ps1.erb'
    end

    windows_task 'logrotate' do
      frequency :daily
      command "powershell -Command #{::File.join(lr_basepath('/bin'), 'run.ps1')}"
      description 'Rotate logs daily'
    end

    seven_zip_tool "7z #{node['sev1-logrotate']['7z']['version']} install" do
      action %i[install add_to_path]
      package "7-Zip #{node['sev1-logrotate']['7z']['version']}"
      # path 'C:\\Program Files\\7-Zip' # must be backslash or the installer will demand to speak to your manager
      source "https://www.7-zip.org/a/7z#{node['sev1-logrotate']['7z']['version'].delete('.')}-x64.msi"
      checksum node['sev1-logrotate']['7z']['checksum']
    end

    # TODO: implement remove action

  end

  def do_package_action(action)
    if windows?
      do_windows_install
    else # linux. you know, *normal*
      package 'logrotate' do
        package_name new_resource.packages
        action action
      end
    end
  end
end

action :install do
  directory lr_basepath('/var/log') do
    action :create
    recursive true
  end

  directory lr_basepath('/etc') do
    action :create
    recursive true
  end

  do_package_action :install

end

action :remove do
  do_package_action :remove
end
