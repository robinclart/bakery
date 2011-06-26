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
          page.output.tap do |output|
            create_file output.path, output, output.options_for_create_file

            if output.error?
              say_status :error, output.path, :red
              say output.full_error_message
              exit
            end
          end
        else
          say_status :skip, page.path, :yellow
        end
      end
    end
  end
end
