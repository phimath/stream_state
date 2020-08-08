library stream_state_builder;

import 'package:flutter/material.dart';
import 'package:stream_state/stream_state.dart';

/// A builder that listens to a [StreamState] for changes.
///
class StreamStateBuilder<T> extends StatelessWidget {
  /// The [StreamState] to listen to changes. When it's state is modified, the builder
  /// will rebuild.
  final StreamState streamState;

  /// The Widget Builder function that will be re triggered when the [StreamState] changes.
  final Function(BuildContext context, T state) builder;
  StreamStateBuilder({@required this.streamState, @required this.builder});

  @override
  Widget build(BuildContext context) => StreamBuilder<T>(
        initialData: streamState.initial,
        stream: streamState.stream,
        builder: (context, snapshot) => builder(context, snapshot.data),
      );
}

/// An easy way to listen for changes of one or many [StreamState] objects.
///
///
class MultiStreamStateBuilder extends StatefulWidget {
  /// A List of [StreamState] objects to listen to for changes.  When the state
  /// of any of these objects is modified, the builder will rebuild.
  final List<StreamState> streamStates;

  /// This function will be called whenever any of the [StreamState] objects' states
  /// are modified.
  final Function(BuildContext context) builder;

  final MultiStreamState multiStreamState;

  /// An easy way to listen for changes of one or many [StreamState] objects, while
  /// avoiding the nesting that comes from using many [StreamStateBuilder].
  MultiStreamStateBuilder({@required this.streamStates, @required this.builder})
      : multiStreamState = MultiStreamState(streamStates: streamStates);

  @override
  _MultiStreamStateBuilderState createState() =>
      _MultiStreamStateBuilderState();
}

class _MultiStreamStateBuilderState extends State<MultiStreamStateBuilder> {
  @override
  void dispose() {
    super.dispose();
    widget.multiStreamState.cleanUp();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<void>(
      initialData: null,
      stream: widget.multiStreamState.stream,
      builder: (context, snapshot) => widget.builder(context));
}

mixin _AsAlias {}

/// MSSB is identical to, and just shorthand for [MultiStreamStateBuilder]
/// Please reference the [MultiStreamStateBuilder] docs for information on its use.
class MSSB = MultiStreamStateBuilder with _AsAlias;
