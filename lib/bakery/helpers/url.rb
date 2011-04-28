module Bakery
  module Helpers
    module Url
      def link(name, options = {})
        attributes = ""
        unless options.empty?
          options.each { |k,v| attributes += " #{k}=\"#{v.to_s}\"" }
        end

        "<a href=\"#{url}#{attributes}>#{name}</a>"
      end

      def url
        item.output_path.gsub("public/", Bakery.config.root_url).gsub("index.html", "")
      end
    end
  end
end
