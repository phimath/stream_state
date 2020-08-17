import 'dart:async';

import 'package:flutter/material.dart';

import '../stream_state.dart';

/// A helper class to facilitate the [MultiStreamStateBuilder] ability
/// to listen to multiple [StreamState] objects
class MultiStreamState {
  /// The list of [StreamState] objects that we will listen to for changes.
  final List<StreamState> streamStates;

  final StreamController _streamController = StreamController();

  cleanUp() => _subscriptions.forEach((subscription) => subscription.cancel());

  List<StreamSubscription> _subscriptions = [];

  /// This is the multi state broadcast stream
  Stream stream;

  /// A helper class to facilitate the [MultiStreamStateBuilder] ability
  /// to listen to multiple [StreamState] objects
  MultiStreamState({@required this.streamStates}) {
    stream = _streamController.stream.asBroadcastStream();
    for (StreamState streamState in streamStates) {
      StreamSubscription subscription = streamState.stream.listen((value) {
        _streamController.add(null);
      });
      _subscriptions.add(subscription);
    }
  }
}
