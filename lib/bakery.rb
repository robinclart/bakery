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

  autoload :Page,       "bakery/page"
  autoload :Output,     "bakery/output"
  autoload :Template,   "bakery/template"
  autoload :Partial,    "bakery/partial"
  autoload :Context,    "bakery/context"
  autoload :Helpers,    "bakery/helpers"

  autoload :Interface,  "bakery/interface"
  autoload :Commands,   "bakery/commands"
  autoload :Generators, "bakery/generators"

  def self.config
    @@config ||= OpenStruct.new({
      :root_url => "/",
      :models => ["page"],
      :routes => {},
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
