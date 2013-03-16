module CookbookLogrotate
  DIRECTIVES = %w[
        compress        copy        copytruncate    daily           dateext
        delaycompress   ifempty     mailfirst       maillast        missingok
        monthly         nocompress  nocopy          nocopytruncate  nocreate
        nodelaycompress nodateext   nomail          nomissingok     noolddir
        nosharedscripts noshred     notifempty      sharedscripts   shred
        weekly          yearly
    ]

  VALUES = %w[
        compresscmd    uncompresscmd  compressext    compressoptions
        create         dateformat     include        mail
        maxage         minsize        rotate         size
        shredcycles    start          tabooext
    ]

  SCRIPTS = [ 'firstaction', 'prerotate', 'postrotate', 'lastaction', ]

  DIRECTIVES_AND_VALUES = DIRECTIVES + VALUES

  class LogrotateConfiguration
    attr_reader :directives, :values, :paths

    class << self
      def from_hash hash
        return LogrotateConfiguration.new hash
      end

      def directives_from hash
        hash.select { |k, v| DIRECTIVES.include?(k) && v }.keys
      end

      def values_from hash
        hash.select { |k| VALUES.include? k }
      end

      def paths_from hash
        hash.select { |k| !(DIRECTIVES_AND_VALUES.include? k) }.inject({}) do | accum_paths, (path, config) |
          accum_paths[path] = {
            'directives' => directives_from(config),
            'values' => values_from(config),
            'scripts' => scripts_from(config)
          }

          accum_paths
        end
      end

      def scripts_from hash
        defined_scripts = hash.select { |k| SCRIPTS.include? k }
        defined_scripts.inject({}) do | accum_scripts, (script, lines) |
          if lines.respond_to? :join
            accum_scripts[script] = lines.join "\n"
          else
            accum_scripts[script] = lines
          end

          accum_scripts
        end
      end
    end

    private

    def initialize hash
      @directives = LogrotateConfiguration.directives_from hash
      @values = LogrotateConfiguration.values_from hash
      @paths = LogrotateConfiguration.paths_from hash
    end
  end
end
