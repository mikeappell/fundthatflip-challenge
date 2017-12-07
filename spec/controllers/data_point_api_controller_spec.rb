require 'rails_helper'

RSpec.describe Api::V1::DataPointsController, type: :controller do
  fixtures :data_points

  let(:expected_attributes) { %w(main_temp main_humidity main_pressure visibility wind_speed date_and_time time weather) }

  describe "GET index" do
    it "returns a JSON object of no more than the 20 most recent DataPoints" do
      get :index
      expect(JSON.parse(response.body).length).to eq data_point_count
    end

    it "returns a JSON object containing parsed DataPoints" do
      get :index
      present_attributes = JSON.parse(response.body).first.keys.sort
      expect(present_attributes).to eq expected_attributes.sort
    end
  end
end

def data_point_count
  DataPoint.count > 20 ? 20 : DataPoint.count
end
