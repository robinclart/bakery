module Bakery
  module Commands
    def self.alias_command(scope, *aliases)
      scope = scope.to_s

      @@aliases ||= {}
      @@aliases[scope] ||= []

      aliases << "-#{scope[0]}" << "--#{scope}" if aliases.empty?

      aliases.each { |a| @@aliases[scope] << a.to_s }
    end

    def self.command_path(command)
      alias_command command, command

      @@aliases.each do |scope,aliases|
        return "bakery/commands/#{scope}" if aliases.include?(command)
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/commands/*.rb"].sort.each do |path|
  require "bakery/commands/#{File.basename(path, '.rb')}"
end
