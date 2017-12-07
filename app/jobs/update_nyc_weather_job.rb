#
# Poll OpenWeatherMap API for current weather in NYC, then save to database
#
class UpdateNYCWeatherJob < ApplicationJob
  queue_as :high_priority

  def perform
    current_api_data_point = WeatherAPIWrapper.new.poll_location_weather
    new_data_point = DataPoint.find_or_initialize_from_api_data_point(current_api_data_point)
    new_data_point.save! unless new_data_point.persisted?
  end
end
