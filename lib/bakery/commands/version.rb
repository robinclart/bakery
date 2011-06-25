module Bakery
  module Commands
    alias_command :version

    module Version extend self
      def start
        puts "Bakery v#{Bakery::VERSION}"
      end
    end
  end
end
