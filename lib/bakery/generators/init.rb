module Bakery
  module Generators
    class Init < Base
      namespace :init
      desc "Initialize a new bakery repository"
      class_option :force, :optional => true, :default => false, :aliases => ["-f"]

      def create_bakefile
        template "Bakefile.tt", "Bakefile"
      end

      def create_index_template
        empty_directory Bakery::Template::DIRECTORY.to_s
        template "template.tt", Bakery::Template::DIRECTORY.join("index.html.erb").to_s
      end
    end
  end
end