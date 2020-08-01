# stream_state

StreamState is an extremely simple wrapper around streams for use as state management.

The included example also uses a singleton to store the state for simplicity,
but this could be stored in a stateful widget or accessed by any other means.

## Getting Started

To add some new bit of state simply create a `StreamState` with a type and an initial value:
```dart
    var counter = StreamState<int>(initial: 0);
    var useRedText = StreamState<bool>(initial: true);

```

You can then update the state:
```dart
    counter++;
    useRedText = !useRedText;
```

Use StreamStateBuilder's to automatically update your UI with these changes:
```dart
    StreamStateBuilder(
        streamState: useRedText,
        builder: (context, useRedTextState) => StreamStateBuilder(
            streamState: counter,
            builder: (context, counterState) => Text(
                counterState.toString(),
                style: TextStyle(color: useRedTextState ? Colors.red : null),
        ), //StreamStateBuilder
    ), //StreamStateBuilder
```


