#
# Represents a single DataPoint from the OpenWeatherMap API
#
class DataPoint < ApplicationRecord
  ATTRIBUTE_API_MAP = HashWithIndifferentAccess.new(
    location_id: ['id'],
    name: ['name'],
    sys_country: ['sys', 'country'],
    sys_sunrise: ['sys', 'sunrise'],
    sys_sunset: ['sys', 'sunset'],
    coord_lat: ['coord', 'lat'],
    coord_lon: ['coord', 'lon'],
    weather_id: ['weather', 0, 'id'],
    weather_main: ['weather', 0, 'main'],
    weather_description: ['weather', 0, 'description'],
    weather_icon: ['weather', 0, 'icon'],
    main_temp: ['main', 'temp'],
    main_pressure: ['main', 'pressure'],
    main_humidity: ['main', 'humidity'],
    main_temp_min: ['main', 'temp_min'],
    main_temp_max: ['main', 'temp_max'],
    visibility: ['visibility'],
    wind_speed: ['wind', 'speed'],
    wind_deg: ['wind', 'deg'],
    wind_gust: ['wind', 'gust'],
    clouds_all: ['clouds', 'all'],
    dt: ['dt']
  )

  def self.find_or_initialize_from_api_data_point(api_data_point)
    data_point = DataPoint.find_by(dt: api_data_point['dt'])

    unless data_point.present?
      data_point = DataPoint.new
      ATTRIBUTE_API_MAP.each do |attr, api_attr|
        data_point[attr] = api_data_point.dig(*api_attr)
      end
    end
    data_point
  end

  def date_and_time
    epoch_to_datetime(dt).strftime("%m/%d/%Y %H:%M")
  end

  def time
    epoch_to_datetime(dt).strftime("%H:%M")
  end

  def weather
    self.weather_description.split.map(&:capitalize).join(' ')
  end

  private

  def epoch_to_datetime(time)
    Time.at(time).to_datetime
  end
end
