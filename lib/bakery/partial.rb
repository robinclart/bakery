module Bakery
  class Partial
    def initialize(name)
      @path = Pathname.new(resolve_path(name))
    end

    def path
      @path.to_s
    end

    def content
      @content ||= @path.read
    end

    private

    def resolve_path(name)
      File.join(Template::DIRECTORY, "_#{name}.erb")
    end
  end
end