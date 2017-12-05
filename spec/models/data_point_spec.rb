require 'rails_helper'

RSpec.describe DataPoint, type: :model do
  let(:test_api_data) { HashWithIndifferentAccess.new(coord: { lon: -74.01, lat: 40.71 }, weather: [{ id: 300, main: 'Drizzle', description: 'light intensity drizzle', icon: '09d' }], base: 'stations', main: { temp: 55.56, pressure: 1022, humidity: 87, temp_min: 53.6, temp_max: 57.2 }, visibility: 16093, wind: { speed: 4.7, gust: 7.7, deg: 120 }, clouds: { all: 90 }, dt: 1512489360, sys: { type: 1, id: 2121, message: 0.0151, country: 'US', sunrise: 1512475531, sunset: 1512509312 }, id: 5128581, name: 'New York', cod: 200) }

  describe '#initialize_from_api_data_point' do
    it 'initializes a new DataPoint from API-provided data' do
      data_point = DataPoint.initialize_from_api_data_point(test_api_data)
      expect(data_point.save!).to be_truthy

      DataPoint::ATTRIBUTE_API_MAP.each do |attr, api_attr|
        expect(data_point[attr.to_s]).to eq test_api_data.dig(*api_attr)
      end
    end
  end
end
