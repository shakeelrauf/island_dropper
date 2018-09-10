require 'faraday'
require 'json'

class Getswift::DistanceMeasure
  BASE = 'http://maps.googleapis.com/'

  def self.api
    Faraday.new(url: BASE) do |faraday|
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.headers['Content-Type'] = 'application/json'
    end
  end
end