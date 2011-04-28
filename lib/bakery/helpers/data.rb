module Bakery
  module Helpers
    module Data
      def data
        item.data
      end

      def title
        data.title
      end

      def author
        data.author
      end

      def published_at
        Time.parse(data.published_at)
      end

      def email
        data.email
      end
    end
  end
end