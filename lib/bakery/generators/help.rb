module Bakery
  module Generators
    class Help < Thor::Group
      include Thor::Actions

      namespace :help
      desc "Show some help."
      argument :command, :optional => true

      def show_help
        if command
          Generators.const_get(command.camelize).help(Thor::Base.shell.new)
        else
          say "help"
        end
      end
    end
  end
end
