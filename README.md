

# StreamState
#### *Extremely simple and easy to use state management*



* Easy to learn and use
* No boilerplate
* No reactive programming knowledge required
* Automatic state persistence -- save the state of your variables between app launches! (Uses [Hive](https://pub.dev/packages/hive) under the hood)
* VS Code snippets available for common tasks

**You do not need to understand what streams are, or how to use them to use this package.** 

StreamState is a very simple and easy to use state management option for those new to declarative / react style programming.  It has no boilerplate, and also offers easy automatic state persistence (it will automatically save the state of your variables between app launches).

 


## General concept

The main idea in reactive style programming is that your UI just shows the current state of your app.  Instead of manually telling a `Text` widget to change the string it is displaying, you store that string in a variable somewhere, and any time that variable changes, the text widget automatically updates.


If you're used to programming UIs in an imperative style (Qt for example), this can be a hard concept to adjust to at first, but I promise its really awesome, powerful and enjoyable to use once it 'clicks'.



## How to use
>The included counter example manages 2 pieces of state, an `int` called **counter** that stores how many times we have pressed a button, and a `bool` called **useRedText** that says if we should display the counter using red text or not.

**Create state:**

For each piece of state that you want to manage, create a `StreamState` object with an initial value. Each `StreamState` object can manage state of any type, including custom classes:

```dart
    var counter = StreamState<int>(initial: 0);
    var useRedText = StreamState<bool>(initial: true);

```
**Access state:**

The current state of a `StreamState` object is stored in it's `state` attribute:

```dart
    print(counter.state);
    print(useRedText.state);
```

**Update state:**

It is very easy to update the state -- just modify the `state` attribute of the `StreamState` object:
```dart
    counter.state++;
    useRedText.state = !useRedText.state;
```

**Have widgets auto update when state changes:**

To have a widget in your UI automatically update when the state changes, you can use a `MultiStreamStateBuilder` widget. It takes a list of `StreamState` objects and knows to rebuild when any of them change.
```dart
    MultiStreamStateBuilder(
        streamStates: [useRedText], // list of StreamStates to listen to for changes
        builder: (_) => Checkbox(
        value: useRedText.state,
        onChanged: (value) => useRedText.state = value
        ),
    ),
```
**Have widgets watch many states to know when to auto update:**

Here is an example of how easy it is to listen to multiple `StreamState` objects for changes:
```dart
    MultiStreamStateBuilder(
        streamStates: [useRedText, counter], // widget will update when either of these change
        builder: (_) => Text(
            counter.state.toString(),
            style: TextStyle(color: useRedText.state ? Colors.red : null),
        ),
```

**Isn't `MultiStreamStateBuilder` is a lot to type all the time? _You can use `MSSB` instead:_**

Because the `MultiStreamStateBuilder` is used so often, and it's quite a lot to type, there is an alias for it: `MSSB`. The two classes are completely identical, so the following example is the same as the previous:
```dart
    MSSB( // MSSB is just shorthand for MultiStreamStateBuilder. They are identical.
        streamStates: [useRedText, counter], // widget will update when either of these change
        builder: (_) => Text(
            counter.state.toString(),
            style: TextStyle(color: useRedText.state ? Colors.red : null),
        ),
```
**How to handle modification of state when not using `state = x`:**

If you modify your state without using `=`, you need to call `StreamState.forceUpdate()` to trigger widget rebuilds.  For example, if your `StreamState` object is a `List` and you call `myStreamStateList.state.add(new_element)`, the `MultiStreamStateBuilder` widgets won't rebuild until you call `myStreamStateList.forceUpdate()`.


## Easy State Persistence (Save variables across App launches)
SteamState makes it very easy to persist state across app launches.  To allow `StreamState` objects to persist, you must call `await initStreamStatePersist()` when you start your app.  The easiest way to do this is in your `main()` function like so:
```dart
    void main() async {
        await initStreamStatePersist();
        runApp(MyApp());
    }
```



Then you can tell any of your `StreamState` objects to save their state across launches, by simply setting `persist:true` and providing a `persistPath`:
```dart
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
```
The `persistPath` is just a String that uniquely identifies which StreamState object you want to persist.  For simple apps, just using the variable name is fine, but if you have lots of `StreamState` objects that you want to persist, you might want to stay organized by providing a full path like `'/settings/theme/useDarkTheme'`.

#### What types can be persisted?


Currently the types of state that can be persisted are: 
* `int`
* `double`
* `String`
* `bool`
* `List`
* `Set`
* `Map`
* `DateTime`
* `BigInt`
* `Uint8List`

>Please note that types that contain other types, like `List` and `Map` and `Set`, must also only contain the above types in order to be persisted.

I plan on adding serialization and deserialization support for custom types in the future.

StreamState uses [Hive](https://pub.dev/packages/hive) under the hood to persist objects,  so my thanks goes out to [Simon Leier](https://github.com/leisim) for making such an awesome and easy to use package.

## AppManager / Where to store StreamState objects?

For simplicity and ease, the included counter example uses a *singleton* called `AppManager` to store the `StreamState` objects.  This makes it very easy to access your state from anywhere in your app.

Any time you call `AppManager()` it will always return the same object (containing our state).

You can create as many managers as you'd like to separate the logic of your code.  For example you can have an `AuthManager()` that stores state related to login flow and user tokens.

You could also store your `StreamState` objects in any other way, including just in a `Stateful Widget`, or in a class along with some other type of dependency injection like [Provider](https://pub.dev/packages/provider) or [GetIt](https://pub.dev/packages/get_it).


***


### Why make this package?
Flutter was my first experience with declarative / react style programming. 

When first getting into Flutter I was overwhelmed by the complexity and start up investment needed to explore, learn and choose a state management solution.  

I just wanted to find something that was very simple to grasp and that I could start implementing immediately so that I could continue learning the bulk and fun parts of Flutter.

Most of the available state management solutions involved very heady concepts and had lots of boilerplate to get started.  

I made this package because it would have made making my first few apps a much more pleasant experience.


### Do you need help?
I'm now a massive fan of Flutter and react style programming. I'm still learning but also want to give back and help others where I can. If you need help implementing this or are struggling with the concepts, feel free to reach out!