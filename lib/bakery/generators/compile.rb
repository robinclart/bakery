module Bakery
  module Generators
    class Compile < Thor::Group
      include Thor::Actions

      namespace :compile
      desc "Compile all items."
      argument :path, :optional => true
      class_option :force, :optional => true, :default => false, :aliases => ["-f"]

      def setup
        Bakery.configure!
      end

      def create_public_directory
        empty_directory "public"
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
        item_model = path.split(File::SEPARATOR).first.singularize

        if Bakery.config.models.include?(item_model)
          item = Bakery::Item.new(path)
          create_item_file item
        else
          say "Add #{item_model} to your 'config.models' (see Bakefile)", :red
        end
      end

      def create_item_file(item)
        say_status "compile", "#{item.path} -> #{item.template_path}", :cyan
        output_content = item.output!

        if item.output_error
          remove_file item.output_path, :verbose => false
          say_status "error", item.output_path, :red
          say "Run 'open #{item.output_path}' for more information on the error."
          say "Once you have fixed the issue run 'bake #{item.path} -f' to recompile it."
        end

        create_file item.output_path, output_content, :verbose => !item.output_error
        exit if item.output_error
      end
    end
  end
end
