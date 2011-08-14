require "pathname"
require "thor/group"
require "active_support/inflector"

module Bakery
  module Generators
    autoload :New,        "bakery/generators/new"
    autoload :Output,     "bakery/generators/output"
    autoload :Page,       "bakery/generators/page"
    autoload :Template,   "bakery/generators/template"

    def self.start
      if ARGV.shift and ARGV.first
        generator.start
      else
        puts "need a generators name" # FIXME
      end
    end

    private

    def self.generator
      "bakery/generators/#{ARGV.shift}".camelize.constantize
    rescue NameError
      puts "Invalid generator: #{File.basename(generator)}"
      exit
    end
  end

  class Generator < Thor::Group
    include Thor::Actions

    def self.source_root
      File.expand_path("../generators/templates/", __FILE__)
    end
  end
end