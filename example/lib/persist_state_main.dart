import 'package:flutter/material.dart';
import 'package:stream_state/stream_state.dart';
import 'package:stream_state/stream_state_builder.dart';

class PersistManager {
  /// This is a singleton so that we can easily access our StreamState
  /// obects from anywhere in our code.
  ///
  /// You can make as many Managers as you want, to keep different types of state together.
  /// for example, having a AuthManager to store state about log-in flow, the user, or tokens.
  ///
  /// The following 3 lines are boilerplate of setting up the singleton.
  static final PersistManager _singleton = PersistManager._internal();
  factory PersistManager() => _singleton;
  PersistManager._internal();

  /// This is the state of our application.
  var counter = StreamState<int>(
    initial: 0,
    persist: true,
    persistPath: 'counter',
  );
  var useRedText = StreamState<bool>(
    initial: true,
    persist: true,
    persistPath: 'useRedText',
  );
}

void main() async {
  await initStreamStatePersist();
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
        title: Text('StreamState Persist Example'),
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
                streamStates: [PersistManager().useRedText],
                builder: (_) => Checkbox(
                  value: PersistManager().useRedText.state,
                  onChanged: (value) =>
                      PersistManager().useRedText.state = value,
                ),
              ),
            ],
          ),
          Text('You have pushed the button this many times:'),
          // Use a builder to display the text of counter in the correct color
          // Note that MSSB is identical to and just shorthand for MultiStreamStateBuilder
          MSSB(
            streamStates: [
              PersistManager().useRedText,
              PersistManager().counter
            ],
            builder: (_) => Text(
              PersistManager().counter.state.toString(),
              style: Theme.of(context).textTheme.headline4.copyWith(
                  color: PersistManager().useRedText.state ? Colors.red : null),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Modify the counter state when button is pressed
        onPressed: () => PersistManager().counter.state++,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
