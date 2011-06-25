module Bakery
  module Generators
    class Init < Base
      namespace "init"
      desc "Initialize a new bakery repository"
      class_option :force, optional: true, default: false, aliases: ["-f"]

      def create_bakefile
        template "Bakefile.tt", "Bakefile"
      end

      def create_template_directory
        empty_directory Bakery::Template::DIRECTORY.to_s
      end

      def create_default_template
        template "template.tt", Bakery::Template::DIRECTORY.join("page.html.erb").to_s
      end

      def create_pages_directory
        empty_directory Bakery::Page::DIRECTORY.to_s
      end

      def create_output_directory
        empty_directory Bakery::Output::DIRECTORY.to_s
      end
    end
  end
end