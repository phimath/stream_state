library stream_state;

import 'dart:typed_data';

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
/// [StreamState] objects can manage any class or type.
class StreamState<T> {
  /// The initial value of this object. It can be any type of object,
  /// including custom classes.
  final T initial;
  T _current;

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

  /// This is the stream of state.  You can use Stream.listen() to add a callback
  /// to this stream
  Stream stream;

  /// Build a StreamState with an [initial] value.
  StreamState(
      {@required this.initial, this.persist = false, this.persistPath}) {
    assert(!persist || persistPath != null,
        '\n\nIf persist is true on any StreamState object, then persistPath must not be null.\n');

    assert(!persist || StreamStatePersist().initialized,
        '\n\nIf persist is true on any StreamState object, then you must initStreamStatePersist()\n\n\n This is normally done like this:\n\nvoid main() async {\n  await initStreamStatePersist();\n  runApp(MyApp());\n}\n\n');

    assert(!persist || StreamStatePersist.supportedTypes.contains(T),
        '\n\n$T is not a StreamState persistable type.\n\nYou can only persist ${StreamStatePersist.supportedTypes.join(' ')} objects with StreamState.\n');

    _current = initial;
    stream = _streamController.stream.asBroadcastStream();

    StreamStatePersist().persist(this);
  }

  /// If the state is mutated without being set directly (like state.add(), or modifying
  /// a custom classes' attributes, we can call forceUpdate() to trigger changes.
  forceUpdate() => state = state;

  resetPersist() => StreamStatePersist().delete(this);

  /// Get the current value of the state
  T get state => _current;

  /// Set the current value of the state.  This will automatically trigger any
  /// StreamStateBuilder or MultiStreamStateBuilder to rebuild.
  set state(T value) {
    _current = value;
    _streamController.add(value);
  }
}
