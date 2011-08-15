require "active_support/inflector"

module Bakery
  module Generators
    def self.generators
      @@generators ||= {}
    end

    def self.register(name, klass)
      generators[name.to_sym] = klass.is_a?(Class) ? klass.name : klass.to_s
    end

    def self.autoload(mod, filename, register = false)
      super(mod, filename)
      register mod.to_s.underscore, filename.camelize if register
    end

    def self.invoke(name)
      generators[name.to_sym].constantize
    rescue
      puts "Invalid generator '#{name}'"
      exit
    end

    autoload :Base,       "bakery/generators/base"
    autoload :New,        "bakery/generators/new", true
    autoload :Output,     "bakery/generators/output", true
    autoload :Page,       "bakery/generators/page", true
    autoload :Template,   "bakery/generators/template", true
  end
end