#
# Cookbook:: logrotate
# Resource:: global
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

unified_mode true

include ::Logrotate::Cookbook::LogrotateHelpers

property :config_file, String,
          default: '/etc/logrotate.conf'

property :template_owner, String,
          default: 'root'

property :template_group, String,
          default: 'root'

property :template_mode, String,
          default: '0644'

property :cookbook, String,
          default: 'logrotate'

property :template_name, String,
          default: 'logrotate-global.erb'

property :options, [String, Array],
          default: %w(weekly dateext),
          coerce: proc { |p| options_from(p.is_a?(Array) ? p : p.split) }

property :includes, [String, Array],
          default: [],
          coerce: proc { |p| p.is_a?(Array) ? p : p.split }

property :parameters, Hash,
          default: { 'rotate' => 4, 'create' => nil },
          coerce: proc { |p| parameters_from(p) }

property :paths, Hash,
          default: {},
          coerce: proc { |p| paths_from(p) }

property :scripts, Hash,
          default: {},
          coerce: proc { |p| scripts_from(p) }

action :create do
  template new_resource.config_file do
    cookbook new_resource.cookbook
    source new_resource.template_name

    owner new_resource.template_owner
    group new_resource.template_group
    mode new_resource.template_mode

    sensitive new_resource.sensitive

    variables(
      includes: new_resource.includes,
      options: new_resource.options,
      parameters: new_resource.parameters,
      paths: new_resource.paths,
      scripts: new_resource.scripts
    )

    helpers(Logrotate::Cookbook::TemplateHelpers)

    action :create
  end
end

action :delete do
  file new_resource.config_file do
    action :delete
  end
end
