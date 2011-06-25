module Bakery
  module Commands
    alias_command :generate, "g"

    module Generate extend self
      def start
        generator_name = ARGV.shift
        setup(generator_name)
        generator = "bakery/generators/#{generator_name}"

        require generator
        generator.camelize.constantize.start
      rescue LoadError
        puts "Invalid generator (#{generator_name})."
        exit
      end

      def setup(generator_name)
        load "Bakefile" unless generator_name == "init"
      rescue LoadError
        puts "This is not a bakery. Please run 'bake init' first."
        exit
      end

      def implicit_output?
        ARGV.empty? or ARGV.first.match(/^-f|--force|--no-force$/) or File.exist?(ARGV.first)
      end

      def implicit_generator?
        ["init", "output"].include? ARGV.first
      end
    end
  end
end
