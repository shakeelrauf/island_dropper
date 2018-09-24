
require 'net/http'
require 'faraday'
require 'json'

class Getswift::DistanceMeasure
  BASE = 'https://maps.googleapis.com/'

  def self.api
    Faraday.new(url: BASE) do |faraday|
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.headers['Content-Type'] = 'application/json'
    end
  end
  def method_name
	url = URI.parse('http://www.example.com/index.html')
	req = Net::HTTP::Get.new(url.to_s)
	res = Net::HTTP.start(url.host, url.port) {|http|
	  http.request(req)
	}
  end
end