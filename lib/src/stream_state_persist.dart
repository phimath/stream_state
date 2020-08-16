import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stream_state/stream_state.dart';

class StreamStatePersist {
  static final StreamStatePersist _singleton = StreamStatePersist._internal();
  factory StreamStatePersist() => _singleton;
  StreamStatePersist._internal();

  Box streamStateBox;
  static const String boxName = '_streamStatePersist';

  bool initialized = false;

  initDb() async {
    await Hive.initFlutter();
    streamStateBox = await Hive.openBox(boxName);
    initialized = true;
  }

  void persist(StreamState streamState) {
    // initialize value
    var initial = read(streamState.persistPath, streamState.initial);
    streamState.state = initial;

    // record changes
    streamState.stream.listen((value) => write(streamState.persistPath, value));
  }

  void write(String path, dynamic value) => streamStateBox.put(path, value);

  read(String path, dynamic defaultValue) =>
      streamStateBox.get(path, defaultValue: defaultValue);

  void delete(StreamState streamState) =>
      streamStateBox.delete(streamState.persistPath);
}
