class Api::V1::DataPointsController < Api::V1::ApiController
  NUMBER_OF_DATAPOINTS = 12

  def index
    data_points = DataPoint.order(dt: :asc)
                           .limit(NUMBER_OF_DATAPOINTS)
                           .select('distinct on (dt) *')
                           .as_json(only: %i[main_temp
                                             main_humidity
                                             main_pressure
                                             visibility
                                             wind_speed],
                                    methods: %i[date weather])

    render json: data_points
  end
end
