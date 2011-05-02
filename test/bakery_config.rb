Bakery.configure do

  config.root_url = "http://example.com/"

  config.models += ["post", "article"]

  config.output_paths.merge!({
    :post => "blog/:base/:author/:wrong/:year/:month/:day/:name",
    :article => ":base/:sub/:name/index"
  })

end
