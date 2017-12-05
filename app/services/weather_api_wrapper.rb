class WeatherAPIWrapper
  include HTTParty

  base_uri 'api.openweathermap.org'
  default_timeout 5

  def api_key
    ENV['OPENWEATHERMAP_API_KEY']
  end

  # Returns T in Fahrenheit
  def base_path
    "/data/2.5/weather?APPID=#{ api_key }&units=imperial&q="
  end

  def handle_timeouts
    begin
      yield
    rescue Net::OpenTimeout, Net::ReadTimeout
      {}
    end
  end

  def poll_location_weather(city_name = 'new york')
    handle_timeouts do
      url = "#{ base_path }#{ city_name }"
      self.class.get(url).parsed_response
    end
  end
end
