require "sinatra"
require "sinatra/reloader"
require "better_errors"
require "binding_of_caller"
require "uri"
require "net/http"

# Need this configuration for better_errors
use(BetterErrors::Middleware)
BetterErrors.application_root = __dir__
BetterErrors::Middleware.allow_ip!('0.0.0.0/0.0.0.0')

get("/") do
  erb(:homepage)
end

post("/search") do
  @artist_name = params.fetch("artist_name")
  @artist = @artist_name.gsub(" ", "%20")

  url = URI("https://deezerdevs-deezer.p.rapidapi.com/search?q=#{@artist}")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  puts request = Net::HTTP::Get.new(url)
  request["X-RapidAPI-Key"] = '5d880456a9mshed52c4ed9073f38p138f93jsn7b5e093bf090'
  request["X-RapidAPI-Host"] = 'deezerdevs-deezer.p.rapidapi.com'

  response = http.request(request)
  @raw_response = response.read_body

  @parsed_response = JSON.parse(@raw_response)

  @data_hash = @parsed_response.dig("data")
  
  erb(:search_results)
end
