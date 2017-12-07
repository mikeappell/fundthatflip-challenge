class Api::V1::DataPointsController < Api::V1::ApiController
  NUMBER_OF_DATAPOINTS = 20

  def index
    data_points = DataPoint.order(dt: :desc)
                           .first(NUMBER_OF_DATAPOINTS)
                           .reverse
                           .as_json(only: %i[main_temp
                                             main_humidity
                                             main_pressure
                                             visibility
                                             wind_speed],
                                    methods: %i[date_and_time
                                                time
                                                weather])

    render json: data_points
  end
end
