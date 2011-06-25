require "pathname"
require "date"
require "time"
require "yaml"
require "ostruct"
require "erb"
require "redcarpet"
require "active_support/dependencies/autoload"
require "active_support/inflector"

require "bakery/version"

module Bakery
  extend ActiveSupport::Autoload

  autoload :Routing
  autoload :Page
  autoload :Output
  autoload :Template
  autoload :Partial
  autoload :Context
  autoload :Helpers
  autoload :Interface
  autoload :Commands
  autoload :Generators
end
