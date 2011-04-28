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
  autoload :Context,    "bakery/context"
  autoload :Snippet,    "bakery/snippet"
  
  autoload :Helpers,    "bakery/helpers"

  module Paths
    def root
      Pathname.new File.expand_path('.')
    end

    def public_folder
      root + 'public'
    end
  end

  module Config
    def config
      @@config ||= OpenStruct.new({
        :root_url => "/",
        :models => ["page"],
        :output_directories => {
          :page => "public"
        },
        :sync => {},
        :helpers => [Helpers::Data, Helpers::Url]
      })
    end

    def configure(&block)
      module_eval(&block)
    end

    def configure!
      load "#{Bakery.root}/Bakefile"
    rescue LoadError
      puts "Not a bakery repository. Run 'bakery init' first"
      exit
    end
  end

  extend Paths
  extend Helpers
  extend Config
end
