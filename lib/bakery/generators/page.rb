module Bakery
  module Generators
    class Page < Base
      desc "Create a new page."
      argument :title
      argument :fields, optional: true, type: :hash
      class_option :directory, optional: true, default: "", aliases: ["-d"]
      class_option :extension, optional: true, default: "html", aliases: ["-e"]
      class_option :force, optional: true, default: false, aliases: ["-f"]

      def create_the_page
        filename = [title.parameterize, options[:extension], "md"].join(".")
        path = Bakery::Page::DIRECTORY.join(options[:directory], filename).to_s
        template "page.tt", path
      end
    end
  end
end