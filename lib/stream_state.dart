library stream_state;

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:stream_state/src/stream_state_persist.dart';

/// Sets up persistance of StreamState objects.  This should be called
/// with an await in main, like:
/// void main() async {
///   await initStreamStatePersist();
///   runApp(MyApp());
/// }
/// StreamState use Hive in the background to persist state.
initStreamStatePersist() async {
  await StreamStatePersist().initDb();
}

/// A thin wrapper around streams to act as a simple state management solution.
///
/// While you dont need to provide [<T>] its good practice to do so.
/// Each [StreamState] object manages a single variable / value of type [<T>]
/// [StreamState] objects can manage any class or type.  [StreamState] objects
/// can also be told to automatically persist their state between app launches.

class StreamState<T> {
  /// The initial value of this object. It can be any type of object,
  /// including custom classes.
  final T initial;

  final StreamController<T> _streamController = StreamController<T>();

  /// If [persist] is true, this StreamState will automatically save the current
  /// state so that it remains the same in between app launches.
  /// StreamState use Hive in the background to persist state.
  final bool persist;

  /// If [persist] is true, you MUST provide a [persistPath] string.  This can be
  /// as simple as the name of the variable like 'useDarkMode'.  For larger apps with
  /// lots of persisted state, it might be a good idea to help organize with a path like
  /// '/settings/theme/useDarkMode', but this changes nothing under the hood and is still
  /// just treated as a string.
  /// StreamState use Hive in the background to persist state.
  final String persistPath;

  /// Set to [true] to clear the persisted state and reset this StreamState
  /// back to the initial value. This can be useful while developing as an
  /// alternative to [resetPersist()]
  final bool forceResetPersist;

  /// This function must be provided to persist custom classes. It must return a
  /// directly serializeable type.
  final dynamic Function(dynamic state) serialize;

  /// This function must be provided to persist custom classes. It should return
  /// an instance of your custom class.
  final T Function(dynamic serialized) deserialize;

  /// This is the stream of state.  You can use Stream.listen() to add a callback
  /// to this stream
  Stream stream;

  T _current;

  /// Build a StreamState with an [initial] value.
  StreamState(
      {@required this.initial,
      this.persist = false,
      this.persistPath,
      this.forceResetPersist = false,
      this.serialize,
      this.deserialize}) {
    assert(!persist || persistPath != null,
        '\n\nIf persist is true on any StreamState object, then persistPath must not be null.\n');

    assert(!persist || StreamStatePersist().initialized,
        '\n\nIf persist is true on any StreamState object, then you must initStreamStatePersist()\n\n\n This is normally done like this:\n\nvoid main() async {\n  await initStreamStatePersist();\n  runApp(MyApp());\n}\n\n');

    assert(
        (serialize != null && deserialize != null) ||
            !persist ||
            StreamStatePersist.supportedTypes.contains(T),
        '\n\nIn order to persist <$T> you must provide both serialize() and deserialize() functions.\n');

    _current = initial;
    stream = _streamController.stream.asBroadcastStream();

    if (forceResetPersist) StreamStatePersist().delete(this);

    if (persist) StreamStatePersist().persist(this);
  }

  /// If the state is mutated without being set directly (like state.add(), or modifying
  /// a custom classes' attributes, we can call forceUpdate() to trigger changes.
  forceUpdate() => state = state;

  /// You can call this method to clear the persisted state from this StreamState object
  /// and reset it back to the initial value.
  resetPersist() {
    StreamStatePersist().delete(this);
    state = initial;
  }

  /// Get the current value of the state
  T get state => _current;

  /// Set the current value of the state.  This will automatically trigger any
  /// StreamStateBuilder or MultiStreamStateBuilder to rebuild.
  ///
  set state(T value) {
    _current = value;
    _streamController.add(value);
  }

  void update(T value) {
    _current = value;
    _streamController.add(value);
  }
}
