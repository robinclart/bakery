module Bakery
  module Commands
    alias_command :generate, "g"

    module Generate extend self
      def start
        generator_name = ARGV.shift
        generator = "bakery/generators/#{generator_name}"

        require generator
        generator.camelize.constantize.start
      rescue LoadError
        puts "Invalid generator: #{generator_name}"
        exit
      end

      def init?
        ARGV.first.eql?("init")
      end

      def output?
        ARGV.first.eql?("output")
      end

      def implicit_output?
        ARGV.empty? or ARGV.first.match(/^-f|--force|--no-force$/) or File.exist?(ARGV.first)
      end

      def implicit_generator?
        init? or output?
      end
    end
  end
end
