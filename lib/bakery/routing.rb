module Bakery
  module Routing extend self
    def draw(&block)
      module_eval(&block)
    end

    def route(rule)
      @@routes ||= {}
      @@routes.merge!(rule)
    end

    def routes
      @@routes ||= {}
    end

    def root(url = nil)
      @@root ||= "http://#{File.basename(Dir.pwd)}/"
      url ? @@root = url : @@root
    end
  end
end
