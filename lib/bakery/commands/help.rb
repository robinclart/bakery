module Bakery
  module Commands
    alias_command :help

    module Help extend self
      def start
        puts "help"
      end
    end
  end
end
