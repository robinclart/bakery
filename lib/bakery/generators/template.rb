module Bakery
  module Generators
    class Template < Base
      desc "Create a new template."
      argument :title
      class_option :extension, optional: true, default: "html", aliases: ["-e"]
      class_option :force, optional: true, default: false, aliases: ["-f"]

      def create_the_template
        filename = [title, options[:extension], "erb"].join(".")
        template "template.tt", Bakery::Template::DIRECTORY.join(filename).to_s
      end
    end
  end
end