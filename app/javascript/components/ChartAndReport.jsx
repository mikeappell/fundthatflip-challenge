import React, { Component } from 'react';
import PropTypes from 'prop-types';
import jQuery from 'jquery';
import { XYPlot, XAxis, YAxis, HorizontalGridLines, LabelSeries, LineSeries } from 'react-vis';

window.jQuery = jQuery;
window.$ = jQuery;

export default class ChartAndReport extends Component {
  constructor(props) {
    super(props);
    this.state = { weatherData: [] }
  }

  static propTypes = {
    dataPointsUrl: PropTypes.string.isRequired,
  }

  componentDidMount = () => {
    this.getWeatherData();
  }

  formatTickLabel = (t, i) => {
    return this.state.weatherData.filter((item) => { return item.x === i })[0].label;
  }

  getWeatherData = () => {
    $.ajax({
      type: 'GET',
      url: this.props.dataPointsUrl,
      success: (data) => {
        const weatherData = data.map((datum, i) => { return { x: i, y: datum.main_temp, label: datum.date } });
        this.setState({ weatherData });
      }
    })
  }

  render() {
    return (
      <div>
        <XYPlot
          width={1200}
          height={300}>
          <HorizontalGridLines />
          <LineSeries
            data={this.state.weatherData}/>
          <XAxis tickFormat={this.formatTickLabel} tickTotal={this.state.weatherData.length}/>
          <YAxis />
        </XYPlot>
      </div>
    )
  }
}