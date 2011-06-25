module Bakery
  module Commands
    alias_command :generate, "g"

    module Generate extend self
      def start
        Generators.load("bakery/generators/#{ARGV.shift}").start
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
