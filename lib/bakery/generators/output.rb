module Bakery
  module Generators
    class Output < Base
      namespace "output"
      desc "Generate the output for all pages or for a specific one if the first arguent is a path."
      argument :path, :optional => true
      class_option :force, :optional => true, :default => false, :aliases => ["-f"]

      def create_public_directory
        empty_directory Bakery::Output::DIRECTORY.to_s
      end

      def compile
        path ? compile_a_single_page : compile_all_pages
      end

      private

      def compile_all_pages
        Bakery::Page.all.each do |page|
          create_page page
        end
      end

      def compile_a_single_page
        create_page Bakery::Page.new(path)
      end

      def create_page(page)
        if page.data.published        
          say_status "compile", "#{page.path} -> #{page.template.path}", :cyan
          result = page.render

          if result[:status] == "error"
            remove_file page.output.path, :verbose => false
            say_status "error", page.output.path, :red
            say "Run 'open #{page.output.path}' for more information on the error."
            say "Once you have fixed the issue run 'bake #{page.path} -f' to recompile it."
          end

          create_file page.output.path, page.output.content, :verbose => !result[:exception]
          exit if result[:exception]
        else
          say_status :skip, page.path, :yellow
        end
      end
    end
  end
end
