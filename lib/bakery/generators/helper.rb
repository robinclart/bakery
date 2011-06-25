module Bakery
  module Generators
    class Helper < Base
      namespace "generate helper"
      desc "Create a new helper."
      argument :name
      class_option :force, optional: true, default: false, aliases: ["-f"]

      def create_the_helper
        filename = [name.parameterize("_"), "rb"].join(".")
        template "helper.tt", File.join("helpers", filename)
      end
    end
  end
end
