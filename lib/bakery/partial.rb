module Bakery
  class Partial
    def initialize(name)
      @pathname = Pathname.new(resolve_path(name))
    end

    attr_reader :pathname

    def path
      @pathname.to_s
    end

    def content
      @content ||= @pathname.read
    end

    private

    def resolve_path(name)
      Template::DIRECTORY.join("_#{name}.erb").to_s
    end
  end
end