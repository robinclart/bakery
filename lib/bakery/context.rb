module Bakery
  class Context
    def initialize(item)
      @item = item
    end

    attr_reader :item

    def render(source)
      ERB.new(source).result(binding)
    end

    def partial(name)
      render Partial.new(name).content
    end

    def markdown(source)
      Redcarpet.new(source).to_html
    end
  end
end
