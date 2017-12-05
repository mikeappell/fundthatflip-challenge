class DataPointsController < Api::V1::ApiController
  NUMBER_OF_DATAPOINTS = 20

  def index
    DataPoint.order(created_at: :desc).first(NUMBER_OF_DATAPOINTS)
  end
end
