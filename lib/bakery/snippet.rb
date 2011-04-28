module Bakery
  class Snippet
    attr_reader :path

    def initialize(name)
      @path = File.join("snippets", "#{name}.html")
    end

    def content
      @content ||= File.read(path)
    end
  end
end