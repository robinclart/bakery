module Bakery
  module Generators
    class New < Thor::Group
      include Thor::Actions

      namespace :new
      desc "Create a new page."
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

      def create_item_directory
        empty_directory Bakery::Item::DIRECTORY.to_s
      end

      def create_item_file
        if Bakery.config.models.include?(model)
          item_filename = title.parameterize + options[:extension]
          item_path = Bakery::Item::DIRECTORY.join(options[:directory], item_filename)
          template "item.tt", item_path.to_s
        else
          say "Add #{model} to your 'config.models' (see Bakefile)", :red
        end
      end
    end
  end
end
