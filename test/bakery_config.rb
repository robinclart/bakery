Bakery::Routing.draw do

  # The full url of your website. If your website is going to live in a
  # sub-directory you have to supply it too into the url. Don't forget the
  # trailing slash.
  # If you don't supply this, all generated urls will be relative to the host.
  root "http://example.com/"

  route post: "blog/:model/:author/:wrong/:year/:month/:day/:filename"

end
