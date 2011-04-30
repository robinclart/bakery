Bakery.configure do

  config.root_url = "http://example.com/"

  config.models += ["post"]

  config.output_directories.merge!({
    :page => "",
    :post => "blog/:base/:author/:wrong/:year/:month/:day"
  })

end
