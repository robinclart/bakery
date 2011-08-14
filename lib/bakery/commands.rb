require "thor"

module Bakery
  class Commands < Thor
    desc "version", "Prints the version number"
    def version
      puts "bakery v#{Bakery::VERSION}"
    end

    desc "help", "Prints the help"
    def help
      puts "help"
    end
  end
end