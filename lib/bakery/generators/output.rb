module Bakery
  module Generators
    class Output < Base
      desc "Generate the output for all pages or for a specific one if the first arguent is a path."
      class_option :force, optional: true, default: false, aliases: ["-f"]

      def setup_bake
        @old_bake = File.read(".baked") if File.exist?(".baked")
        @new_bake = ""
      end

      def create_pages
        Bakery::Page.all.each do |page|
          if page.data.published.is_a? FalseClass
            say_status :skip, page.path, :yellow
          else
            @new_bake += "#{page.output.path}\n"
            create_file page.output.path, page.output
          end
        end
      end

      def save_baked_file_and_cleanup
        create_file ".baked", @new_bake, force: true, verbose: false
        if defined?(@old_bake)
          @old_bake.split(/\n/).each { |path| remove_file path unless @new_bake.include?(path) }
        end
      end
    end
  end
end