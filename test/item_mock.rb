module Bakery
  class Item
    def raw
      <<-eof
---
title: Test
template: special.html
published_at: 29 April 2011
author: John Doe
---

# Test

Here comes some content
eof
    end
  end
end
