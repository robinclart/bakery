require 'sinatra'

get '*/' do
  File.read(File.join("public#{request.path_info}", 'index.html'))
end
