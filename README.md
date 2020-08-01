

# StreamState

#### *Extremely simple and easy to use state management*
StreamState is a simple state management option for those struggling with declarative / react style programming.

You do not need to understand what streams are, or how to use them to use this package.  In fact if you *do* understand them well, than this style of state management is likely too simple a solution for what you are doing.


## General concept

The main idea in reactive style programming is that your UI just shows the current state of your app.  Instead of manually telling a `Text` widget to change the string it is displaying, you store that string in a variable somewhere, and any time that variable changes, the text widget automatically updates.


If you're used to programming UIs in an imperative style (Qt for example), this can be a hard concept to adjust to at first, but I promise its really awesome, powerful and enjoyable to use once it 'clicks'.


## How to use

For each piece of state that you want to manage, create a `StreamState` object with an initial value:

```dart
    var counter = StreamState<int>(initial: 0);
    var useRedText = StreamState<bool>(initial: true);

```

The current state of a `StreamState` object is stored in it's `.state` attribute:

```dart
    print(counter.state);
    print(useRedText.state);
```


It is very easy to update the state, just modify the `state` attribute of the `StreamState` object:
```dart
    counter.state++;
    useRedText.state = !useRedText.state;
```

To have a widget in your UI automatically update when the state changes, you can use a `StreamStateBuilder` widget:

```dart
    StreamStateBuilder<int>( // its good practice to tell the builder the type of the state (int)
        streamState: counter // give the builder the StreamState object
        builder: (context, currentState)=> Text('$currentState'), // build a widget using the current state
    )

```


You can nest multiple `StreamStateBuilder` widgets to have access to many state objects at the same time.  If one state will be modified more often than another, its better (but not necessary) to put  it deeper in the tree:

```dart
    StreamStateBuilder<bool>( // users will modify 'useRedText' less often, so we put it on the outside
        streamState: useRedText, // provide the 'useRedText' StreamState object
        builder: (context, useRedTextState) => StreamStateBuilder<int>( // counter will change more often so its deeper in the tree
            streamState: counter, // provide the 'counter' StreamState object
            builder: (context, counterState) => Text(
                '$counterState', // we can access the counterState
                style: TextStyle(color: useRedTextState ? Colors.red : null), // and also the useRedText state
        ),
    ), 
```
> Don't stress too much about the ordering of nested builders.  Flutter rebuilds widgets extremely fast so in practice this isn't too important.


## AppManager

For simplicity, the included counter example uses a *singleton* to store the `StreamState` objects.  This makes it very easy to access your state from anywhere in your app. You can create as many of these singletons as you'd like to separate the logic of your code.

You could also store your StreamStates in any other way, including just in a stateful widget.


## Why make this pacakge?
Flutter was my first experience with declarative / react style programming. 

When first getting into Flutter I was overwhelmed by the complexity and start up investment needed to explore, learn and choose a state management solution.  

I just wanted to find something that was very simple to grasp and that I could start implementing immediately so that I could continue learning the bulk and fun parts of flutter.

I made this package because it would have made making my first few apps a much more pleasant experience.