module Bakery
  module Helpers
    module Url
      def link(name = item.data.title, options = {})
        attrs = ""
        options.each { |k,v| attrs += " #{k}=\"#{v}\"" } unless options.empty?
        "<a href=\"#{url}\"#{attrs}>#{name || url}</a>"
      end

      def url
        item.output.path.gsub("#{Bakery::Output::DIRECTORY}/",
          Bakery.config.root_url).gsub(/index.htm[l]?$/, "")
      end
    end
  end
end
