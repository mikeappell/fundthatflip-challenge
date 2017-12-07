require 'rails_helper'

RSpec.describe DataPoint, type: :model do
  let(:test_api_data) { HashWithIndifferentAccess.new(coord: { lon: -74.01, lat: 40.71 }, weather: [{ id: 300, main: 'Drizzle', description: 'light intensity drizzle', icon: '09d' }], base: 'stations', main: { temp: 55.56, pressure: 1022, humidity: 87, temp_min: 53.6, temp_max: 57.2 }, visibility: 16093, wind: { speed: 4.7, gust: 7.7, deg: 120 }, clouds: { all: 90 }, dt: 1512489360, sys: { type: 1, id: 2121, message: 0.0151, country: 'US', sunrise: 1512475531, sunset: 1512509312 }, id: 5128581, name: 'New York', cod: 200) }
  let(:test_epoch_date) { 1512502562 }

  describe '#find_or_initialize_from_api_data_point' do
    it 'initializes a new DataPoint from API-provided data' do
      data_point = DataPoint.find_or_initialize_from_api_data_point(test_api_data)
      expect(data_point.persisted?).to be_falsey
      expect(data_point.save!).to be_truthy

      DataPoint::ATTRIBUTE_API_MAP.each do |attr, api_attr|
        expect(data_point[attr.to_s]).to eq test_api_data.dig(*api_attr)
      end
    end

    it "doesn't persist a new DataPoint if a duplicate 'dt' exists in the database" do
      duplicate_dt = 1512502562
      DataPoint.create!(dt: duplicate_dt)
      duplicate_data_point = DataPoint.find_or_initialize_from_api_data_point(test_api_data.merge(dt: duplicate_dt))
      expect(duplicate_data_point.persisted?).to be_truthy
    end
  end

  describe '#date_and_time' do
    it "converts a DataPoint's 'dt' attribute to a date/time string" do
      expected_datetime_string = "12/05/2017 14:36"
      data_point = DataPoint.new(dt: test_epoch_date)
      expect(data_point.date_and_time).to eq expected_datetime_string
    end
  end

  describe "#time" do
    it "returns the time in military format" do
      expected_time_string = "14:36"
      data_point = DataPoint.new(dt: test_epoch_date)
      expect(data_point.time).to eq expected_time_string
    end
  end

  describe "#weather" do
    it "capitalizes the weather" do
      expected_weather_string = "Cloudy With A Chance Of Meatballs"
      data_point = DataPoint.new(weather_description: "cloudy with a chance of meatballs")
      expect(data_point.weather).to eq expected_weather_string
    end
  end
end
