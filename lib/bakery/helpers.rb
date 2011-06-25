module Bakery
  module Helpers extend self
    DIRECTORY = Pathname.new("helpers")

    def register(helper)
      all << helper
    end

    def all
      @@helpers ||= []
    end

    def load!
      all.each { |helper| load_and_include helper }
    end

    def load_and_include(path)
      load path
      Context.send :include, modulize(path).constantize
    # rescue NameError
    #   puts "#{modulize(path)}:Module was expected from #{path}"
    #   exit
    end

    def modulize(path)
      File.basename(path, ".rb").camelize
    end
  end
end

Dir["helpers/*_helper.rb"].sort.each do |helper_path|
  Bakery::Helpers.register helper_path
end
