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

  Stream stream;

  ///Build a StreamState with an [initial] value.
  StreamState({@required this.initial}) {
    _current = initial;
    stream = _streamController.stream.asBroadcastStream();
  }

  T get state => _current;
  set state(T value) {
    _current = value;
    _streamController.add(value);
  }
}
