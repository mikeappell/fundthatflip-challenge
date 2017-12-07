import React, { Component } from 'react';
import PropTypes from 'prop-types';
import jQuery from 'jquery';
import { XYPlot, XAxis, YAxis, HorizontalGridLines, LabelSeries, LineSeries } from 'react-vis';
import ReactTable from 'react-table';

window.jQuery = jQuery;
window.$ = jQuery;

export default class ChartAndReport extends Component {
  constructor(props) {
    super(props);
    this.state = { chartWeatherData: [], reportWeatherData: [] }
  }

  static propTypes = {
    dataPointsUrl: PropTypes.string.isRequired,
  }

  componentDidMount = () => {
    this.getWeatherData();
  }

  formatTickLabel = (t, i) => {
    return this.state.chartWeatherData.filter((item) => { return item.x === i })[0].label;
  }

  getWeatherData = () => {
    $.ajax({
      type: 'GET',
      url: this.props.dataPointsUrl,
      success: (data) => {
        const chartWeatherData = data.map((datum, i) => { return { x: i, y: datum.main_temp, label: datum.date } });
        this.setState({ chartWeatherData, reportWeatherData: data });
      }
    })
  }

  renderWeatherChart = () => {
    return (
      <div className="WeatherChart">
        <XYPlot
          width={document.body.clientWidth - 20}
          height={300}>
          <HorizontalGridLines />
          <LineSeries
            data={this.state.chartWeatherData}/>
          <XAxis tickFormat={this.formatTickLabel} tickTotal={this.state.chartWeatherData.length}/>
          <YAxis />
        </XYPlot>
      </div>
    )
  }

  renderWeatherReport = () => {
    const columns = [{
      Header: 'Date and Time',
      accessor: 'date',
    },
    {
      Header: 'Temperature (F)',
      accessor: 'main_temp',
    },
    {
      Header: 'Description',
      accessor: 'weather',
    },
    {
      Header: 'Humidity (%)',
      accessor: 'main_humidity',
    },
    {
      Header: 'Pressure (hPa)',
      accessor: 'main_pressure',
    },
    {
      Header: 'Visibility (meters)',
      accessor: 'visibility',
    },
    {
      Header: 'Wind Speed (mph)',
      accessor: 'wind_speed',
    }]
    return (
      <div className="WeatherReport">
        <ReactTable
          className="-striped"
          data={this.state.reportWeatherData}
          columns={columns}
          showPagination={false}
          sortable={false}
          pageSize={12}
        />
      </div>
    )
  }

  render() {
    return (
      <div className="ChartAndReport">
        <h1 className="Header">Most Recent Weather in NYC</h1>
        {this.renderWeatherChart()}
        {this.renderWeatherReport()}
      </div>
    )
  }
}