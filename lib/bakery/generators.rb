require 'thor/group'

module Bakery
  module Generators
    class Base < Thor::Group
      include Thor::Actions

      def self.source_root
        File.expand_path("../generators/templates/", __FILE__)
      end
    end

    def self.load(generator)
      require generator
      generator.camelize.constantize
    rescue LoadError
      puts "Invalid generator: #{File.basename(generator)}"
      exit
    end
  end
end
