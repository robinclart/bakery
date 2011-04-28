%w[ data url ].each do |helper|
  require "bakery/helpers/#{helper}"
end
