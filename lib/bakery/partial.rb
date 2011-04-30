module Bakery
  class Partial
    attr_reader :path

    def initialize(name)
      @path = File.join("templates", "_#{name}.erb")
    end

    def content
      @content ||= File.read(path)
    end
  end
end