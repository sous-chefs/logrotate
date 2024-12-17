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

    # the normal way to install ps modules only works on _some_ windows hosts
    # so we have to fight stupid with more stupid.
    remote_file ::File.join(Chef::Config[:file_cache_path], 'log-rotate.nuget') do
      source "https://psg-prod-eastus.azureedge.net/packages/log-rotate.#{node['sev1-logrotate']['logrotate-powershell']['version']}.nupkg"
    end

    archive_file ::File.join(Chef::Config[:file_cache_path], 'log-rotate.nuget') do
      destination "C:/Program Files/WindowsPowerShell/Modules/Log-Rotate/#{node['sev1-logrotate']['logrotate-powershell']['version']}"
    end

    directory lr_basepath('etc/') do
      recursive true
    end

    template lr_basepath('etc/logrotate.conf') do
      cookbook 'sev1_logrotate'
      source 'logrotate-global.erb'
      helpers(Logrotate::Cookbook::TemplateHelpers)
    end

    directory lr_basepath('bin') do
      action :create
      recursive true
    end

    template lr_basepath('bin/run.ps1') do
      cookbook new_resource.cookbook
      source 'run.ps1.erb'
    end

    windows_task 'logrotate' do
      frequency :daily
      command "powershell -ExecutionPolicy bypass -File #{lr_basepath('bin/run.ps1')}"
      description 'Rotate logs daily'
      run_level :highest
    end

    include_recipe 'sev1_seven_zip_tool::default'

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
  directory lr_basepath('var/log') do
    action :create
    recursive true
  end

  directory lr_basepath('etc') do
    action :create
    recursive true
  end

  do_package_action :install

end

action :remove do
  do_package_action :remove
end
