module Bakery
  module Helpers extend self
    def register(helper)
      list << helper
    end

    def list
      @@helpers ||= []
    end
  end
end

Dir["helpers/*.rb"].sort.each do |path|
  load "helpers/#{File.basename(path, '.rb')}"
  begin
    Bakery::Helpers.register path.camelize.constantize
  rescue NameError
    puts "#{path.camelize.constantize}:Module was expected"
  end
end
