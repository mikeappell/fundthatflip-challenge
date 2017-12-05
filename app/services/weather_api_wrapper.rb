class WeatherAPIWrapper
  include HTTParty

  API_KEY = ENV['OPENWEATHERMAP_API_KEY']
  BASE_PATH = "/data/2.5/weather?APPID=#{ API_KEY }&q="

  base_uri 'api.openweathermap.org'
  default_timeout 5

  def handle_timeouts
    begin
      yield
    rescue Net::OpenTimeout, Net::ReadTimeout
      {}
    end
  end

  def poll_location_weather(city_name = 'new york')
    handle_timeouts do
      url = "#{ BASE_PATH }#{ city_name }"
      self.class.get(url).parsed_response
    end
  end
end
