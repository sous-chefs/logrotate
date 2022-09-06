module Logrotate
  require 'chef'
  class Config
    # Report log files configured for rotation by logrotate, but configuration which is not managed by
    # chef. The point here is to make sure that we don't configure a log file to be rotated twice.
    class Unmanaged
      def initialize
        @log_files = []
      end

      def configs
        cwd = '/etc'

        so = Mixlib::ShellOut.new("logrotate -d #{::File.join(cwd,'logrotate.conf')}")
        so.run_command

        config_files = []

        so.stderr.lines.select { |line| line.start_with?('reading', 'including') }.each do |line|
          line.strip!
          if line =~ /^including/
            cwd = line.split(' ', 2).last
          elsif line =~ /^reading/
            fn = line.split(' ', 4).last
            next if fn.nil?
            config_file = ::File.absolute_path?(fn) ? fn : ::File.join(cwd, fn)
            config_files << config_file

          end
        end
        config_files
      end

      def logs(conf_file)
        so = Mixlib::ShellOut.new("logrotate -d #{conf_file}")
        so.run_command
        log_files = so.stderr.lines.select { |line| line.start_with?('considering log') }
        log_files.map! { |file| file.delete_prefix('considering log') }

        if ::File.readlines(conf_file).any?(/#\s*chef-generated/i)
          @log_files = @log_files - log_files # chef-managed logs
        else
          @log_files = @log_files | log_files # not chef-managed logs
        end
      end

      def report
        configs.each { |config| logs(config) }
        @log_files.map!(&:strip)
        @log_files.flatten.uniq!
      end

      def unmanaged?(log_file)
        log_file.delete!('"')
        @log_files.any? || report
        @log_files.include?(log_file)
      end

    end
  end
end

