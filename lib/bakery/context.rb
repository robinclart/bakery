module Bakery
  class Context
    def initialize(page)
      @page = page
    end

    attr_reader :page

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
