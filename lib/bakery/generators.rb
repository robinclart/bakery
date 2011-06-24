require 'thor/group'

module Bakery
  module Generators
    class Base < Thor::Group
      include Thor::Actions
    end
  end
end
