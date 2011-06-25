require 'pathname'
require 'date'
require 'time'
require 'yaml'
require 'ostruct'
require 'erb'
require 'redcarpet'
require 'active_support/inflector'

module Bakery
  autoload :VERSION,    "bakery/version"

  autoload :Routing,    "bakery/routing"

  autoload :Page,       "bakery/page"
  autoload :Output,     "bakery/output"
  autoload :Template,   "bakery/template"
  autoload :Partial,    "bakery/partial"
  autoload :Context,    "bakery/context"
  autoload :Helpers,    "bakery/helpers"

  autoload :Interface,  "bakery/interface"
  autoload :Commands,   "bakery/commands"
  autoload :Generators, "bakery/generators"
end
