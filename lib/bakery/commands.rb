require "thor"
require "active_support/inflector"

module Bakery
  class Commands < Thor
    class << self
      def is?(name, pos = 0)
        !ARGV[pos].nil? && !!ARGV[pos].match(name)
      end
    end

    desc "version", "Prints the version number"
    def version
      say "bakery v#{Bakery::VERSION}"
    end

    desc "new [NAME]", "Invoke the new generator"
    def new(*args)
      invoke Generators::New
    end

    desc "output", "Invoke the output generator"
    def output
      invoke Generators::Output
    end

    desc "g(enerate)? [GENERATOR]", "Invoke the given generator", alias: "g"
    def generate(*args)
      ARGV.shift
      unless ARGV.first == "base"
        constantize_generator(ARGV.shift).start
      else
        say "Invalid generator 'base'"
      end
    end

    desc "g [GENERATOR]", "Invoke the given generator", hide: true
    alias :g :generate

    private

    def constantize_generator(name)
      "bakery/generators/#{name}".camelize.constantize.start
    rescue
      say "Invalid generator '#{name}'"
      exit
    end
  end
end