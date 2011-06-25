module Bakery
  module Generators
    class Output < Base
      namespace "output"
      desc "Generate the output for all pages or for a specific one if the first arguent is a path."
      argument :path, optional: true
      class_option :force, optional: true, default: false, aliases: ["-f"]

      def compile
        if path
          create_page Bakery::Page.new(path)
        else
          Bakery::Page.all.each { |p| create_page p }
        end
      end

      private

      def create_page(page)
        if page.data.published        
          say_status "compile", "#{page.path} -> #{page.template.path}", :cyan
          result = page.render

          unless result[:error]
            create_file page.output.path, result[:content]
          else
            create_file page.output.path, result[:content], force: true, verbose: false
            say_status "error", page.output.path, :red
            say "Run 'open #{page.output.path}' for more information on the error."
            say "Once you have fixed the issue run 'bake #{page.path} -f' to recompile it."
          end
        else
          say_status :skip, page.path, :yellow
        end
      end
    end
  end
end
