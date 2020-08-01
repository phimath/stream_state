import 'package:flutter/material.dart';
import 'package:stream_state/stream_state.dart';
import 'package:stream_state/stream_state_builder.dart';

class AppManager {
  static final AppManager _singleton = AppManager._internal();
  factory AppManager() => _singleton;
  AppManager._internal();

  var counter = StreamState<int>(initial: 0);
  var useRedText = StreamState<bool>(initial: true);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        title: Text('StreamState Example Counter!'),
        actions: [
          Row(
            children: [
              Text(
                'Use Red Text',
              ),
              StreamStateBuilder(
                streamState: AppManager().useRedText,
                builder: (context, state) => Checkbox(
                  value: AppManager().useRedText.state,
                  onChanged: (value) => AppManager().useRedText.state = value,
                ),
              ),
            ],
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            StreamStateBuilder(
              streamState: AppManager().useRedText,
              builder: (context, colorTextState) => StreamStateBuilder(
                streamState: AppManager().counter,
                builder: (context, counterState) => Text(
                  counterState.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: colorTextState ? Colors.red : null),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppManager().counter.state++,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
