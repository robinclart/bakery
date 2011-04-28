module Bakery
  module Generators
    class Init < Thor::Group
      include Thor::Actions

      namespace :init
      desc "Initialize a new bakery repository"
      class_option :force, :optional => true, :default => false, :aliases => ["-f"]

      def self.source_root
        File.expand_path("../templates/", __FILE__)
      end

      def create_bakefile
        template "Bakefile.tt", "Bakefile"
      end

      def create_index_template
        empty_directory "templates"
        template "template.tt", "templates/index.html.erb"
      end
    end
  end
end