class CreateDataPoints < ActiveRecord::Migration[5.1]
  def change
    create_table :data_points do |t|
      t.integer 'location_id'
      t.string 'name'
      t.string 'sys_country'
      t.integer 'sys_sunrise'
      t.integer 'sys_sunset'
      t.float 'coord_lat'
      t.float 'coord_lon'
      t.integer 'weather_id'
      t.string 'weather_main'
      t.string 'weather_description'
      t.string 'weather_icon'
      t.float 'main_temp'
      t.integer 'main_pressure'
      t.integer 'main_humidity'
      t.float 'main_temp_min'
      t.float 'main_temp_max'
      t.integer 'visibility'
      t.float 'wind_speed'
      t.integer 'wind_deg'
      t.float 'wind_gust'
      t.integer 'clouds_all'
      t.integer 'dt'

      t.timestamps
    end
  end
end
