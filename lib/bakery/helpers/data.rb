module Bakery
  module Helpers
    module Data
      extend Forwardable

      def_delegator  :page, :data
      def_delegators :data, :title, :author, :category

      def published_at
        Time.parse(data.published_at)
      end
    end
  end
end
