# Represents a single DataPoint from the OpenWeatherMap API
class DataPoint < ApplicationRecord
  def self.initialize_from_api_data_point(api_data_point)
    data_point = self.new
    data_point.location_id = api_data_point['id']
    data_point.name = api_data_point['name']
    data_point.sys_country = api_data_point['sys']['country']
    data_point.sys_sunrise = api_data_point['sys']['sunrise']
    data_point.sys_sunset = api_data_point['sys']['sunset']
    data_point.coord_lat = api_data_point['coord']['lat']
    data_point.coord_lon = api_data_point['coord']['lon']
    data_point.weather_id = api_data_point['weather'][0]['id']
    data_point.weather_main = api_data_point['weather'][0]['main']
    data_point.weather_description = api_data_point['weather'][0]['description']
    data_point.weather_icon = api_data_point['weather'][0]['icon']
    data_point.main_temp = api_data_point['main']['temp']
    data_point.main_pressure = api_data_point['main']['pressure']
    data_point.main_humidity = api_data_point['main']['humidity']
    data_point.main_temp_min = api_data_point['main']['temp_min']
    data_point.main_temp_max = api_data_point['main']['temp_max']
    data_point.visibility = api_data_point['visibility']
    data_point.wind_speed = api_data_point['wind']['speed']
    data_point.wind_gust = api_data_point['wind']['gust']
    data_point.clouds_all = api_data_point['clouds']['all']
    data_point.dt = api_data_point['dt']

    data_point
  end
end
