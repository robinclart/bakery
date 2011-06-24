module Bakery
  module Generators
    class New < Base
      namespace :new
      desc "Create a new page."
      argument :model
      argument :title
      class_option :directory, :optional => true, :default => "", :aliases => ["-d"]
      class_option :extension, :optional => true, :default => "html", :aliases => ["-e"]
      class_option :force, :optional => true, :default => false, :aliases => ["-f"]

      def self.source_root
        File.expand_path("../templates/", __FILE__)
      end

      def create_a_file
        if model == "template"
          create_a_template
        elsif model == "partial"
          create_a_partial
        elsif Bakery.config.models.include?(model)
          create_an_item
        else
          say "Add #{model} to your 'config.models' (see Bakefile)", :red
        end
      end

      private

      def create_a_template
        template_filename = title + "." + options[:extension] + ".erb"

        empty_directory Bakery::Template::DIRECTORY.to_s
        template "template.tt", Bakery::Template::DIRECTORY.join(template_filename).to_s
      end

      def create_a_partial
        partial_filename = "_" + title + "." + options[:extension] + ".erb"

        empty_directory Bakery::Template::DIRECTORY.to_s
        create_file Bakery::Template::DIRECTORY.join(partial_filename).to_s
      end

      def create_an_item
        item_filename = title.parameterize + "." + options[:extension] + ".md"
        item_path = Bakery::Item::DIRECTORY.join(options[:directory], item_filename).to_s

        empty_directory Bakery::Item::DIRECTORY.to_s
        template "item.tt", item_path
      end
    end
  end
end
