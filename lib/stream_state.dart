library stream_state;

import 'package:flutter/material.dart';
import 'dart:async';

class StreamState<T> {
  final T initial;
  T _current;

  final StreamController<T> _streamController = StreamController<T>();

  Stream stream;

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
