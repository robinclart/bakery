require 'thor/group'

%w[ init new compile ].each do |generator|
  require "bakery/generators/#{generator}"
end
