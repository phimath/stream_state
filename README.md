

# StreamState
#### *Extremely simple and easy to use state management*
StreamState is a simple state management option for those struggling with declarative / react style programming.

**You do not need to understand what streams are, or how to use them to use this package.**  In fact if you *do* understand them well, than this style of state management might be too simple a solution for what you are doing.


## General concept

The main idea in reactive style programming is that your UI just shows the current state of your app.  Instead of manually telling a `Text` widget to change the string it is displaying, you store that string in a variable somewhere, and any time that variable changes, the text widget automatically updates.


If you're used to programming UIs in an imperative style (Qt for example), this can be a hard concept to adjust to at first, but I promise its really awesome, powerful and enjoyable to use once it 'clicks'.


## How to use
>The included counter example manages 2 pieces of state, an `int` called **counter** that stores how many times we have pressed a button, and a `bool` called **useRedText** that says if we should display the counter using red text or not.


For each piece of state that you want to manage, create a `StreamState` object with an initial value. Each `StreamState` object can manage state of any type, including custom classes:

```dart
    var counter = StreamState<int>(initial: 0);
    var useRedText = StreamState<bool>(initial: true);

```

The current state of a `StreamState` object is stored in it's `state` attribute:

```dart
    print(counter.state);
    print(useRedText.state);
```


It is very easy to update the state -- just modify the `state` attribute of the `StreamState` object:
```dart
    counter.state++;
    useRedText.state = !useRedText.state;
```

To have a widget in your UI automatically update when the state changes, you can use a `MultiStreamStateBuilder` widget. It takes a list of `StreamState` and knows to rebuild when any of them change.
```dart
    MultiStreamStateBuilder(
        streamStates: [AppManager().useRedText], // list of StreamStates to listen to for changes
        builder: (_) => Checkbox(
        value: AppManager().useRedText.state,
        onChanged: (value) => AppManager().useRedText.state = value
        ),
    ),
```





<!-- 
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

*** -->

## AppManager / Where to store StreamState objects?

For simplicity, the included counter example uses a *singleton* to store the `StreamState` objects.  This makes it very easy to access your state from anywhere in your app. You can create as many of these singletons as you'd like to separate the logic of your code.

Any time you use `AppManager()` it will always return the same object (containing our state).

You could also store your `StreamState` objects in any other way, including just in a `Stateful Widget`.



***


### Why make this package?
Flutter was my first experience with declarative / react style programming. 

When first getting into Flutter I was overwhelmed by the complexity and start up investment needed to explore, learn and choose a state management solution.  

I just wanted to find something that was very simple to grasp and that I could start implementing immediately so that I could continue learning the bulk and fun parts of Flutter.

Most of the available state management solutions involved very heady concepts and had lots of boilerplate to get started.  

I made this package because it would have made making my first few apps a much more pleasant experience.

Also, as a somewhat novice Flutter developer (this is my first package) I want to get feedback from the community on why this might be a bad way to work.

### Do you need help?
I'm now a massive fan of Flutter and react style programming. I'm still learning but also want to give back and help others where I can. If you need help implementing this or are struggling with the concepts, feel free to reach out!