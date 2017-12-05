#
# Poll OpenWeatherMap API for current weather in NYC, then save to database
#
class UpdateNYCWeatherJob < ApplicationJob
  queue_as :high_priority

  def perform
    current_data_point = WeatherAPIWrapper.new.poll_location_weather
    DataPoint.initialize_from_api_data_point(current_data_point).save!
  end
end
