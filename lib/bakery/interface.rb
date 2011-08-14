require "bakery"
require "bakery/commands"
require "bakery/generators"

module Bakery
  module Interface extend self
    def run
      bootload
      Commands.start
      exit
    end

    private

    def bootload
      ARGV.unshift("output") if ARGV.empty? or Commands.is?(/^-f|--force|--no-force$/)

      unless Commands.is?(/^new|help|version$/)
        Dir["lib/*.rb"].each { |file| require file }

        begin
          load "Bakefile"
        rescue LoadError
          puts "This is not a bakery. Please run 'bake new NAME' first."
          exit
        end
      end
    end
  end
end