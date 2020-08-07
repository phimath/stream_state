import 'package:flutter/material.dart';
import 'package:stream_state/stream_state.dart';
import 'package:stream_state/stream_state_builder.dart';

class AppManager {
  static final AppManager _singleton = AppManager._internal();
  factory AppManager() => _singleton;
  AppManager._internal();

  /// This is the state of our application.
  var wordList = StreamState<List<String>>(initial: []);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreamState Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamStateExample(),
    );
  }
}

class StreamStateExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StreamState Example'),
      ),
      body: MultiStreamStateBuilder(
          streamStates: [AppManager().wordList],
          builder: (_) {
            return ListView.builder(
                itemCount: AppManager().wordList.state.length,
                itemBuilder: (context, i) => Text(i.toString()));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppManager().wordList.state.add('test');
          // because we are modifying state with 'add' and not setting it directly ( with =),
          // we need to forceUpdate the StreamState
          AppManager().wordList.forceUpdate();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
