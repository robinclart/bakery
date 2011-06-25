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

Dir["helpers/*.rb"].sort.each do |helper_path|
  helper = File.basename(helper_path, ".rb").camelize
  load helper_path

  begin
    Bakery::Helpers.register helper.constantize
  rescue NameError
    puts "#{helper}:Module was expected from #{helper_path}"
    exit
  end
end
