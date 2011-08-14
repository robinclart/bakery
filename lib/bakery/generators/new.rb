module Bakery
  module Generators
    class New < Base
      desc "Initialize a new bakery repository"
      argument :name
      class_option :force, optional: true, default: false, aliases: ["-f"]

      def create_bakery
        empty_directory name
      end

      def create_bakefile
        template "Bakefile.tt", "#{name}/Bakefile"
      end

      def create_lib_directory
        empty_directory "#{name}/lib"
      end

      def create_template_directory
        empty_directory "#{name}/#{Bakery::Template::DIRECTORY.to_s}"
      end

      def create_default_template
        template "template.tt", "#{name}/#{Bakery::Template::DIRECTORY.join("page.html.erb").to_s}"
      end

      def create_pages_directory
        empty_directory "#{name}/#{Bakery::Page::DIRECTORY.to_s}"
      end

      def create_output_directory
        empty_directory "#{name}/#{Bakery::Output::DIRECTORY.to_s}"
      end
    end
  end
end