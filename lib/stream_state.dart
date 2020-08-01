library stream_state;

import 'package:flutter/material.dart';
import 'dart:async';

/// A thin wrapper around streams to act as a simple state management solution.
/// While you dont need to provide [<T>] its good practice to do so.
/// Each [StreamState] object manages a single variable / value of type [<T>]
/// [StreamState] objects can manage any class or type.
class StreamState<T> {
  /// initial value of this object
  final T initial;
  T _current;

  final StreamController<T> _streamController = StreamController<T>();

  // This is the stream of state.  You can use [Stream.listen()] to add a callback
  // to this stream
  Stream stream;

  /// Build a StreamState with an [initial] value.
  StreamState({@required this.initial}) {
    _current = initial;
    stream = _streamController.stream.asBroadcastStream();
  }

  /// Get the current value of the state
  T get state => _current;

  /// Set the current value of the state.  This will automatically trigger any
  /// StreamStateBuilder or MultiStreamStateBuilder to rebuild.
  set state(T value) {
    _current = value;
    _streamController.add(value);
  }
}

class MultiState {
  final Map<StreamState, dynamic> initial;
  Map<StreamState, dynamic> _states = {};

  MultiState({@required List<StreamState> initial})
      : initial = {
          for (StreamState streamState in initial)
            streamState: streamState.state
        };

  getState(StreamState streamState) => _states[streamState];

  updateState({@required StreamState streamState, @required dynamic value}) {
    _states[streamState] = value;
  }
}

class MultiStreamState {
  final List<StreamState> streamStates;

  final StreamController<MultiState> _streamController =
      StreamController<MultiState>();

  Stream stream;

  final MultiState multiState;

  MultiStreamState({@required this.streamStates})
      : multiState = MultiState(streamStates) {
    stream = _streamController.stream.asBroadcastStream();
    for (StreamState streamState in streamStates) {
      streamState.stream.listen((value) {
        multiState.updateState(streamState: streamState, value: value);
        _streamController.add(multiState);
      });
    }
  }
}
