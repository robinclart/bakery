require 'thor/group'

%w[ init help template item compile ].each do |generator|
  require "bakery/generators/#{generator}"
end

module Bakery
  module Generators
    def self.invoke(command)
      const_get(command.camelize).start
    # rescue NameError
    #   ARGV.clear and Help.start
    end
  end
end
