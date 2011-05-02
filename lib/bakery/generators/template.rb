module Bakery
  module Generators
    class Template < Thor::Group
      include Thor::Actions

      namespace :template
      desc "Create a new template"
      argument :name, :required => true
      class_option :force, :optional => true, :default => false, :aliases => ["-f"]

      def self.source_root
        File.expand_path("../templates/", __FILE__)
      end

      def create_index_template
        empty_directory Bakery::Template::DIRECTORY.to_s
        template "template.tt", "#{Bakery::Template::DIRECTORY}/#{name}.html.erb"
      end
    end
  end
end