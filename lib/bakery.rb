# stdlib
require 'pathname'
require 'date'
require 'time'
require 'yaml'
require 'ostruct'
require 'forwardable'
require 'erb'

# 3rd party libraries
require 'redcarpet'
require 'active_support/inflector'

module Bakery
  autoload :VERSION,    "bakery/version"

  autoload :Item,       "bakery/item"
  autoload :Template,   "bakery/template"
  autoload :Partial,    "bakery/partial"
  autoload :Context,    "bakery/context"
  autoload :Helpers,    "bakery/helpers"
  autoload :Commands,   "bakery/commands"
  autoload :Generators, "bakery/generators"

  def self.config
    @@config ||= OpenStruct.new({
      :root_url => "/",
      :models => ["page"],
      :output_paths => {},
      :helpers => [Helpers::Data, Helpers::Url]
    })
  end

  def self.configure(&block)
    module_eval(&block)
  end

  def self.load_config!
    load "Bakefile"
  end
end
