module Bakery
  module Commands
    def self.alias_command(scope, *aliases)
      @@_commands ||= {}
      @@_commands[scope.to_s] ||= []

      aliases.each { |a| @@_commands[scope.to_s] << a.to_s }
    end

    def self.command_path(command)
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
