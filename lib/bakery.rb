$:.unshift File.expand_path("../../lib", __FILE__)

# stdlib
require 'pathname'
require 'date'
require 'time'
require 'yaml'
require 'ostruct'
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

  def self.config
    @@config ||= OpenStruct.new({
      :root_url => "/",
      :models => ["page"],
      :output_directories => {
        :page => ""
      },
      :sync => {},
      :helpers => [Helpers::Data, Helpers::Url]
    })
  end

  def self.configure(&block)
    module_eval(&block)
  end

  def self.configure!
    load "Bakefile"
  end
end
