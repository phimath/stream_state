

## StreamState

StreamState is an extremely thin wrapper around streams to make them a very simple but easy to use state management option.


## How to use

To add some new bit of state simply create a `StreamState` with an initial value:
```dart
    var counter = StreamState<int>(initial: 0);
    var useRedText = StreamState<bool>(initial: true);

```


It is very easy to update the state:
```dart
    counter++;
    useRedText = !useRedText;
```


StreamStateBuilders will automatically update your UI when the state changes:
```dart
    StreamStateBuilder<bool>(
        streamState: useRedText,
        builder: (context, useRedTextState) => StreamStateBuilder<int>(
            streamState: counter,
            builder: (context, counterState) => Text(
                counterState.toString(),
                style: TextStyle(color: useRedTextState ? Colors.red : null),
        ), //StreamStateBuilder
    ), //StreamStateBuilder
```

## Included Example

The included counter example uses a singleton to store the state for simplicity.  This makes it very easy to
access your state from anywhere in your app. You can create as many of these singletons as you'd like to
separate the logic of your code.

You could also store your StreamStates in any other way, including just in a stateful widget.