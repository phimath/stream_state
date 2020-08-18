import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:stream_state/stream_state.dart';

import 'init_hive_adapters/init_hive_mobile.dart'
    if (dart.library.html) 'init_hive_adapters/init_hive_web.dart';

class StreamStatePersist {
  static final StreamStatePersist _singleton = StreamStatePersist._internal();
  factory StreamStatePersist() => _singleton;
  StreamStatePersist._internal();

  static const supportedTypes = [
    int,
    double,
    String,
    bool,
    List,
    Set,
    Map,
    DateTime,
    BigInt,
    Uint8List
  ];

  Box streamStateBox;
  static const String boxName = '_streamStatePersist';

  bool initialized = false;

  initDb() async {
    await initHive();
    streamStateBox = await Hive.openBox(boxName);
    initialized = true;
  }

  void persist(StreamState streamState) {
    // initialize value
    if (streamState.deserialize != null) {
      var initialSerialized = streamState.serialize(streamState.initial);
      var serialized = read(streamState.persistPath, initialSerialized);
      print(serialized);
      streamState.state = streamState.deserialize(serialized);
    } else {
      var initial = read(streamState.persistPath, streamState.initial);
      streamState.state = initial;
    }

    // record changes
    streamState.stream.listen((value) {
      if (streamState.serialize != null) value = streamState.serialize(value);
      write(streamState.persistPath, value);
    });
  }

  void write(String path, dynamic value) => streamStateBox.put(path, value);

  Object read(String path, dynamic defaultValue) =>
      streamStateBox.get(path, defaultValue: defaultValue);

  void delete(StreamState streamState) =>
      streamStateBox.delete(streamState.persistPath);
}
