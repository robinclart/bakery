module Bakery
  module Helpers
    module Url
      def link(name, options = {})
        attrs = ""
        options.each { |k,v| attrs += " #{k}=\"#{v}\"" } unless options.empty?
        "<a href=\"#{url}#{attrs}>#{name}</a>"
      end

      def url
        item.output_path.gsub("#{Bakery::Item::PUBLIC_DIRECTORY}/",
          Bakery.config.root_url).gsub(/index.htm[l]?$/, "")
      end
    end
  end
end
