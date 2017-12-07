import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { XYPlot, XAxis, YAxis, HorizontalGridLines, LabelSeries, LineSeries } from 'react-vis';
import ReactTable from 'react-table';

const TimerInterval = 300;

export default class ChartAndReport extends Component {

  constructor(props) {
    super(props);
    this.state = {
      chartWeatherData: [],
      reportWeatherData: [],
      timerTime: TimerInterval,
    }
  }

  static propTypes = {
    dataPointsUrl: PropTypes.string.isRequired,
  }

  componentDidMount = () => {
    this.timer = setInterval(this.timerTick, 1000);
    this.getWeatherData();
  }

  componentWillUnmount = () => { clearInterval(this.timer); }

  formatTickLabel = (t, i) => {
    return this.state.chartWeatherData.filter((item) => { return item.x === i })[0].label;
  }

  getWeatherData = () => {
    $.ajax({
      type: 'GET',
      url: this.props.dataPointsUrl,
      success: (data) => {
        const chartWeatherData = data.map((datum, i) => { return { x: i, y: datum.main_temp, label: datum.time } });
        this.setState({ chartWeatherData, reportWeatherData: data });
      }
    })
  }

  timerTick = () => {
    const newTimerTime = this.state.timerTime - 1;
    if (newTimerTime === 0) {
      this.getWeatherData();
      this.setState({ timerTime: TimerInterval })
    } else {
      this.setState({ timerTime: newTimerTime })
    }
  }

  renderUpdateTimer = () => {
    return (
      <div className="UpdateTimer">
        Updates in&nbsp;
        <span>{this.state.timerTime}</span>
        &nbsp;seconds
        <br />
        (if there's new data)
      </div>
    )
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
      accessor: 'date_and_time',
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
          pageSize={this.state.reportWeatherData.length}
        />
      </div>
    )
  }

  renderInfoBlurb = () => {
    return (
      <div className="InfoBlurb">
        Data polled at five minute invervals from <a href="https://openweathermap.org/api">OpenWeatherMap</a>
      </div>
    )
  }

  render() {
    return (
      <div className="ChartAndReport">
        <h1 className="Header">Most Recent Weather in NYC</h1>
        {this.renderUpdateTimer()}
        {this.renderWeatherChart()}
        {this.renderWeatherReport()}
        {this.renderInfoBlurb()}
      </div>
    )
  }
}