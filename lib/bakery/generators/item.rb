module Bakery
  module Generators
    class Item < Thor::Group
      include Thor::Actions

      namespace :item
      desc "Create a new item."
      argument :model
      argument :title
      class_option :directory, :optional => true, :default => "", :aliases => ["-d"]
      class_option :extension, :optional => true, :default => ".html.md", :aliases => ["-e"]
      class_option :force, :optional => true, :default => false, :aliases => ["-f"]

      def self.source_root
        File.expand_path("../templates/", __FILE__)
      end

      def setup
        Bakery.configure!
      end

      def create_item
        if Bakery.config.models.include?(model)
          empty_directory model.pluralize
          template "item.tt", File.join(model.pluralize, options[:directory], "#{title.parameterize}#{options[:extension]}")
        else
          say "Add #{model} to your 'config.models' (see Bakefile)", :red
        end
      end
    end
  end
end
