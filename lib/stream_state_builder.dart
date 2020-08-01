library stream_state_builder;

import 'package:flutter/material.dart';
import 'package:stream_state/stream_state.dart';

class StreamStateBuilder<T> extends StatelessWidget {
  final StreamState streamState;
  final Type type;
  final Function(BuildContext context, T state) builder;
  StreamStateBuilder(
      {@required this.streamState, @required this.builder, this.type});

  @override
  Widget build(BuildContext context) => StreamBuilder<T>(
        initialData: streamState.initial,
        stream: streamState.stream,
        builder: (context, snapshot) => builder(context, snapshot.data),
      );
}
