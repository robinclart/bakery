module Bakery
  module Interface extend self
    def start
      # Invoke the output command if there is no arguments or if the first
      # argument is an existing file or the force flag.
      ARGV.unshift("output") if Commands::Generate.implicit_output?

      # Invoke with generate without explicitly asking for it.
      ARGV.unshift("generate") if Commands::Generate.implicit_generator?

      begin
        command_name = ARGV.shift
        command = Commands.command_path(command_name).camelize.constantize
      rescue NameError
        puts "Invalid command (#{command_name})."
        exit
      end

      command.start
    end
  end
end
