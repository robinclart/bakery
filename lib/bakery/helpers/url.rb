module Bakery
  module Helpers
    module Url
      def link(name = page.data.title, options = {})
        attrs = ""
        options.each { |k,v| attrs += " #{k}=\"#{v}\"" } unless options.empty?
        "<a href=\"#{url}\"#{attrs}>#{name || url}</a>"
      end

      def url
        page.output.path.gsub("#{Bakery::Output::DIRECTORY}/",
          Bakery::Routing.root).gsub(/index.htm[l]?$/, "")
      end
    end
  end
end
