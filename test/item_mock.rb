module Bakery
  class Item
    def raw
      File.read("test/#{path}")
    end
  end
end
