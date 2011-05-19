Bakery.configure do

  config.root_url = "http://example.com/"

  config.models += ["post", "article"]

  config.output_paths.merge!({
    :post => "blog/:model/:author/:wrong/:year/:month/:day/:filename"
  })

end
