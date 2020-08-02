import 'package:flutter/material.dart';
import 'package:stream_state/stream_state.dart';
import 'package:stream_state/stream_state_builder.dart';

class AppManager {
  /// This is a singleton so that we can easily access our StreamState
  /// obects from anywhere in our code.
  /// The following 3 lines are boilerplate of setting up the singleton.
  static final AppManager _singleton = AppManager._internal();
  factory AppManager() => _singleton;
  AppManager._internal();

  /// This is the state of our application.
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Use Red Text'),
              // Use a builder to display a checkbox that is tied to useRedText state
              MultiStreamStateBuilder(
                streamStates: [AppManager().useRedText],
                builder: (_) => Checkbox(
                  value: AppManager().useRedText.state,
                  onChanged: (value) => AppManager().useRedText.state = value,
                ),
              ),
            ],
          ),
          Text('You have pushed the button this many times:'),
          // Use a builder to display the text of counter in the correct color
          MultiStreamStateBuilder(
            streamStates: [AppManager().useRedText, AppManager().counter],
            builder: (_) => Text(
              AppManager().counter.state.toString(),
              style: Theme.of(context).textTheme.headline4.copyWith(
                  color: AppManager().useRedText.state ? Colors.red : null),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Modify the counter state when button is pressed
        onPressed: () => AppManager().counter.state++,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
