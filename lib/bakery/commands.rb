module Bakery
  module Commands extend self
    def run
      # Invoke the output command if there is no arguments or if the first
      # argument is an existing file or the force flag.
      ARGV.unshift("output") if Generate.implicit_output?

      # Invoke with generate without explicitly asking for it.
      ARGV.unshift("generate") if Generate.implicit_generator?

      command_path(ARGV.shift).camelize.constantize.start
    rescue NameError
      puts "Invalid command (#{command})."
    end

    def alias_command(scope, *aliases)
      @@_commands ||= {}
      @@_commands[scope.to_s] ||= []

      aliases.each { |a| @@_commands[scope.to_s] << a.to_s }
    end

    def command_path(command)
      alias_command command, command

      @@_commands.each do |scope,aliases|
        return "bakery/commands/#{scope}" if aliases.include?(command)
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/commands/*.rb"].sort.each do |path|
  require "bakery/commands/#{File.basename(path, '.rb')}"
end
