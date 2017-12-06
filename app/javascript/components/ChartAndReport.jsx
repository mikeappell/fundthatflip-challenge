import React, { Component } from 'react';
import PropTypes from 'prop-types';

export default class ChartAndReport extends Component {
  static propTypes = {
    dataPointsUrl: PropTypes.string.isRequired,
  }

  render() {
    return (
      <div>
        We React now, fam.
      </div>
    )
  }
}