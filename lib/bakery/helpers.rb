Dir["#{File.dirname(__FILE__)}/helpers/*.rb"].sort.each do |path|
  require "bakery/helpers/#{File.basename(path, '.rb')}"
end
