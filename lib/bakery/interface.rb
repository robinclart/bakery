module Bakery
  module Interface extend self
    def start
      # Invoke the output command if there is no arguments or if the first
      # argument is an existing file or the force flag.
      ARGV.unshift("output") if Generate.implicit_output?

      # Invoke with generate without explicitly asking for it.
      ARGV.unshift("generate") if Generate.implicit_generator?

      command_name = ARGV.shift

      begin
        command = command_path(command_name).camelize.constantize
      rescue NameError
        puts "Invalid command (#{command_name})."
        exit
      end

      command.start
    end
  end
end
