module Bakery
  class Page
    def raw
      File.read("test/#{path}")
    end
  end
end
