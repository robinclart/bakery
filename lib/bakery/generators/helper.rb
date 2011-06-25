module Bakery
  module Generators
    class Helper < Base
      namespace "generate helper"
      desc "Create a new helper."
      argument :name
      class_option :force, optional: true, default: false, aliases: ["-f"]

      def create_the_helper
        filename = "#{name.parameterize("_")}_helper.rb"
        template "helper.tt", Bakery::Helpers::DIRECTORY.join(filename)
      end
    end
  end
end
