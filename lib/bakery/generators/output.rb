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
        path ? compile_a_single_item : compile_all_items
      end

      private

      def compile_all_items
        Bakery::Item.all.each do |item|
          create_item_file item
        end
      end

      def compile_a_single_item
        create_item_file Bakery::Item.new(path)
      end

      def create_item_file(item)
        if item.data.published        
          say_status "compile", "#{item.path} -> #{item.template.path}", :cyan
          result = item.render

          if result[:status] == "error"
            remove_file item.output.path, :verbose => false
            say_status "error", item.output.path, :red
            say "Run 'open #{item.output.path}' for more information on the error."
            say "Once you have fixed the issue run 'bake #{item.path} -f' to recompile it."
          end

          create_file item.output.path, item.output.content, :verbose => !result[:exception]
          exit if result[:exception]
        else
          say_status :skip, item.path, :yellow
        end
      end
    end
  end
end
