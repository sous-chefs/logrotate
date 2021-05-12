#
# Cookbook:: logrotate
# Library:: logrotate
#
# Copyright:: 2013-2019, Chef Software, Inc.
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

module Logrotate
  module Cookbook
    module LogrotateHelpers
      OPTIONS ||= %w(compress copy copytruncate daily dateext
                     dateyesterday delaycompress hourly ifempty mailfirst maillast
                     missingok monthly nocompress nocopy nocopytruncate nocreate nocreateolddir
                     nodelaycompress nodateext nomail nomissingok noolddir
                     nosharedscripts noshred notifempty renamecopy sharedscripts shred weekly
                     yearly).freeze

      PARAMETERS ||= %w(compresscmd uncompresscmd compressext compressoptions
                        create createolddir dateformat include mail extension maxage minsize maxsize
                        rotate size shredcycles start tabooext su olddir).freeze

      SCRIPTS ||= %w(firstaction prerotate postrotate lastaction preremove).freeze

      PARAMETERS_AND_OPTIONS_AND_SCRIPTS ||= PARAMETERS + OPTIONS + SCRIPTS

      def parameters_from(hash)
        hash.sort.select { |k, _| PARAMETERS.include?(k) }.to_h
      end

      def options_from(values)
        values.sort.select { |k, v| OPTIONS.include?(k) && v || v.nil? }.map { |k, _| k }
      end

      def paths_from(hash)
        hash.sort.select { |k, _| !PARAMETERS_AND_OPTIONS_AND_SCRIPTS.include?(k) }.map do |path, config|
          [path, { 'options' => options_from(config), 'parameters' => parameters_from(config), 'scripts' => scripts_from(config) }]
        end.to_h
      end

      def scripts_from(hash)
        hash.sort.select { |k, _| SCRIPTS.include?(k) }.map do |script, lines|
          [script, lines.respond_to?(:join) ? lines.join("\n") : lines]
        end.to_h
      end
    end
  end
end
