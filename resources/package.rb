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

default_action :install
allowed_actions %i[install remove]

action_class do
  def do_package_action(action)
    if windows?
      powershell_package 'Log-Rotate' do
        skip_publisher_check true
        action action
      end
    else # linux. you know, *normal*
      package 'logrotate' do
        package_name new_resource.packages
        action action
      end
    end
  end
end

action :install do
  do_package_action :install
end

action :remove do
  do_package_action :remove
end
