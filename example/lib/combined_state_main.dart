import 'package:flutter/material.dart';
import 'package:stream_state/stream_state.dart';
import 'package:stream_state/stream_state_builder.dart';

class CombinedState {
  StreamState counterA;
  StreamState counterB;
  StreamState totalCount;

  CombinedState() {
    counterA = StreamState<int>(initial: 0);
    counterB = StreamState<int>(initial: 0);
    totalCount = StreamState<int>.combined([counterA, counterB],
        (currentStates) => counterA.state + counterB.state);
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CombinedState Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamStateExample(),
    );
  }
}

class StreamStateExample extends StatefulWidget {
  @override
  _StreamStateExampleState createState() => _StreamStateExampleState();
}

class _StreamStateExampleState extends State<StreamStateExample> {
  var state = CombinedState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CombinedState Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MSSB(
            streamStates: [state.counterA, state.counterB],
            builder: (_) => Text(
              state.totalCount.state.toString(),
              textScaleFactor: 2,
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MSSB(
                streamStates: [state.counterA],
                builder: (_) => RaisedButton(
                  child: Text(state.counterA.state.toString()),
                  onPressed: () => state.counterA.state++,
                ),
              ),
              MSSB(
                streamStates: [state.counterB],
                builder: (_) => RaisedButton(
                  child: Text(state.counterB.state.toString()),
                  onPressed: () => state.counterB.state++,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
