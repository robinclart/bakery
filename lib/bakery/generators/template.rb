module Bakery
  module Generators
    class Template < Base
      namespace "generate page"
      desc "Create a new page."
      argument :title
      class_option :directory, optional: true, default: "", aliases: ["-d"]
      class_option :extension, optional: true, default: "html", aliases: ["-e"]
      class_option :force, optional: true, default: false, aliases: ["-f"]

      def create_the_template
        filename = [title, options[:extension], "erb"].join(".")
        template "template.tt", Bakery::Template::DIRECTORY.join(filename).to_s
      end
    end
  end
end
