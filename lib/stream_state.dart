library stream_state;

import 'package:flutter/material.dart';
import 'dart:async';

/// A thin wrapper around streams to act as a simple state management solution.
///
/// While you dont need to provide [<T>] its good practice to do so.
/// Each [StreamState] object manages a single variable / value of type [<T>]
/// [StreamState] objects can manage any class or type.
class StreamState<T> {
  /// The initial value of this object. It can be any type of object,
  /// including custom classes.
  final T initial;
  T _current;

  final StreamController<T> _streamController = StreamController<T>();

  /// This is the stream of state.  You can use Stream.listen() to add a callback
  /// to this stream
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

/// A helper class to facilitate the [MultiStreamStateBuilder] ability
/// to listen to multiple [StreamState] objects
class MultiStreamState {
  /// The list of [StreamState] objects that we will listen to for changes.
  final List<StreamState> streamStates;

  final StreamController _streamController = StreamController();

  endStream() => _streamController.close();

  /// This is the multi state broadcast stream
  Stream stream;

  /// A helper class to facilitate the [MultiStreamStateBuilder] ability
  /// to listen to multiple [StreamState] objects
  MultiStreamState({@required this.streamStates}) {
    stream = _streamController.stream.asBroadcastStream();
    for (StreamState streamState in streamStates) {
      streamState.stream.listen((value) {
        _streamController.add(null);
      });
    }
  }
}
