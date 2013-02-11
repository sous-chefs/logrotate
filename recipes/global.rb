#
# Cookbook Name:: logrotate
# Recipe:: default
#
# Copyright 2009-2013, Opscode, Inc.
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

include_recipe 'logrotate::default'

def directives 
    %w[
        compress        copy        copytruncate    daily           dateext
        delaycompress   ifempty     mailfirst       maillast        missingok
        monthly         nocompress  nocopy          nocopytruncate  nocreate
        nodelaycompress nodateext   nomail          nomissingok     noolddir
        nosharedscripts noshred     notifempty      sharedscripts   shred
        weekly          yearly
    ]
end

def values 
    %w[ 
        compresscmd    uncompresscmd  compressext    compressoptions
        create         dateformat     include        mail
        maxage         minsize        rotate         size           
        shredcycles    start          tabooext
    ]
end

def scripts
    [ 'firstaction', 'prerotate', 'postrotate', 'lastaction', ]
end

def directives_and_values 
    directives + values
end

def directives_from hash
    hash.select { |k, v| directives.include?(k) && v }.keys
end

def values_from hash
    hash.select { |k| values.include? k }
end

def scripts_from hash
    defined_scripts = hash.select { |k| scripts.include? k }
    defined_scripts.inject({}) do | accum_scripts, (script, lines) |
        if lines.respond_to? :join
            accum_scripts[script] = lines.join "\n"
        else
            accum_scripts[script] = lines
        end

        accum_scripts
    end
end

def paths_from hash
    hash.select { |k| !(directives_and_values.include? k) }.inject({}) do | accum_paths, (path, config) |
        accum_paths[path] = {
            'directives' => directives_from(config),
            'values' => values_from(config),
            'scripts' => scripts_from(config)
        }

        accum_paths
    end
end

defined_directives = directives_from node['logrotate']['global'].to_hash
defined_values = values_from node['logrotate']['global'].to_hash
defined_paths = paths_from node['logrotate']['global'].to_hash

template '/etc/logrotate.conf' do
    source 'logrotate-global.erb'
    mode '644'
    variables({
        :directives => defined_directives,
        :values => defined_values,
        :paths => defined_paths
    })
end
