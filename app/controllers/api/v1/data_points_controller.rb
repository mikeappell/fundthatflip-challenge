class Api::V1::DataPointsController < Api::V1::ApiController
  NUMBER_OF_DATAPOINTS = 12

  def index
    data_points = DataPoint.order(dt: :asc)
                           .limit(NUMBER_OF_DATAPOINTS)
                           .select("distinct on (dt) *")
                           .as_json(only: [:main_temp], methods: [:date])

    render json: data_points
  end
end
