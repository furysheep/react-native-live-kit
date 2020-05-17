import React, { Component } from 'react';
import PropTypes from 'prop-types';
import {
  requireNativeComponent,
  Dimensions,
  NativeModules,
  View,
} from 'react-native';

const { width, height } = Dimensions.get('window');
const RCTStream = requireNativeComponent('RCTStream', Stream);

export default class Stream extends Component {
  constructor(props, context) {
    super(props, context);
    this._onReady = this._onReady.bind(this);
    this._onPending = this._onPending.bind(this);
    this._onStart = this._onStart.bind(this);
    this._onError = this._onError.bind(this);
    this._onStop = this._onStop.bind(this);
  }

  static propTypes = {
    started: PropTypes.bool,
    cameraFronted: PropTypes.bool,
    url: PropTypes.string.isRequired,
    landscape: PropTypes.bool.isRequired,

    onReady: PropTypes.func,
    onPending: PropTypes.func,
    onStart: PropTypes.func,
    onError: PropTypes.func,
    onStop: PropTypes.func,
    ...View.propTypes,
  };

  static defaultProps = {
    cameraFronted: true,
  };

  _onReady(event) {
    this.props.onReady && this.props.onReady(event.nativeEvent);
  }

  _onPending(event) {
    this.props.onPending && this.props.onPending(event.nativeEvent);
  }

  _onStart(event) {
    this.props.onStart && this.props.onStart(event.nativeEvent);
  }

  _onError(event) {
    this.props.onError && this.props.onError(event.nativeEvent);
  }

  _onStop(event) {
    this.props.onStop && this.props.onStop(event.nativeEvent);
  }

  render() {
    let style = this.props.style;
    const nativeProps = {
      onReady: this._onReady,
      onPending: this._onPending,
      onStart: this._onStart,
      onError: this._onError,
      onStop: this._onStop,
      ...this.props,
      style: {
        ...style,
      },
    };

    return <RCTStream {...nativeProps} />;
  }
}
