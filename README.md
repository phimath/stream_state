

# StreamState
#### *Extremely simple and easy to use state management*



* Easy to learn and use
* No boilerplate
* No reactive programming knowledge required
* Automatic state persistence -- save the state of your variables between app launches
* Full Flutter Web support
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

Alternatively, instead of directly modifying state with `state =`, you can use `state.update(newValue)`.  This will make it so you don't need to use `forceUpdate()`.


## Easy State Persistence (Save variables across App launches)

>There is a 2nd example file called `persist_state_main.dart` that shows different persisted `StreamState` objects, including a persisted Custom Class.

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


#### How to reset persisted state back to initial?

You can reset a persisted state back to its initial value with `resetPersist()`:
```dart
    counter.resetPersist();
    useRedText.resetPersist();
```

Or with `forceResetPersist:true`, but be sure not to leave this on as that would always use the initial state on app launch (negating the point of persistence).

```dart
    var counter = StreamState<int>(
        initial: 0,
        persist: true,
        persistPath: 'counter',
        forceResetPersist: true, // Be sure not to leave this on!!
    );
```


#### What types can be persisted?


Currently the types of state that can be directly persisted are: 
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

#### What about persisting custom classes?

You can persist custom objects by providing serialization and deserialization functions. The serialization function must serialize the `state` to one of the above directly persistable types (such as a `Map` in the following example), and the deserialization function should return your object.

```dart
    var custom = StreamState<Custom>(
        initial: Custom(name: 'My Persisted Custom Class', awesomeness: 10),
        persist: true,
        persistPath: 'custom',
        serialize: (state) => state.toMap(),
        deserialize: (serialized) => Custom.fromMap(serialized),
    );
```

StreamState uses [Hive](https://pub.dev/packages/hive) under the hood to persist objects,  so my thanks goes out to [Simon Leier](https://github.com/leisim) for making such an awesome and easy to use package.

## Derived / Combined State

You can derive a combined `StreamState` from other `StreamState` objects with the named constructor `StreamState.combined()`.

You can combine as many `StreamState` objects as you want.  The combiner will give you access to them as a list, but you can also use your `StreamState` objects directly.

Using StreamStates directly:

```dart
    counterA = StreamState<int>(initial: 0);
    counterB = StreamState<int>(initial: 0);
    totalCount = StreamState<int>.combined(
        [counterA, counterB],
        (_) => counterA.state + counterB.state,
    );
```

Using passed StreamStates:
```dart
    counterA = StreamState<int>(initial: 0);
    counterB = StreamState<int>(initial: 0);
    totalCount = StreamState<int>.combined(
        [counterA, counterB],
        (currentStates) => currentStates[0].state + currentStates[1].state,
    );
```

>Note that you can't directly persist a combined `StreamState` (but there shouldn't be a need to do this.)

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

I made this package because it would have made making my first few apps a much more pleasant experience.  All of the design goals of **StreamState** are built around making it as simple and easy to use and learn as possible.


### Do you need help?
I'm now a massive fan of Flutter and react style programming. I'm still learning but also want to give back and help others where I can. If you need help implementing this or are struggling with the concepts, feel free to reach out!


***

### VSCode Snippets:
You can add the following VSCode Snippets to help make using this package even easier and faster to use.  To use them, go to File -> Preferences -> User Snippets and then select Dart, and add the snippets:

```
"MultiStreamStateBuilder": {
		"prefix": [
			"mssb"
		],
		"body": [
			"MSSB(",
			"streamStates:[$1],",
			"builder: (_) =>"
		],
		"description": "Adds a MultiStreamStateBuilder header. Use 'Wrap with Widget' and then select 'Widget: child:' and replace with this snippet."
	},
	"StreamState": {
		"prefix": [
			"ss"
		],
		"body": [
			"var ${1:name} = StreamState<${2:type}>(initial:${3:initial value});"
		],
		"description": "Adds a StreamState object."
	},
	"Singleton": {
		"prefix": [
			"singleton"
		],
		"body": [
			"class $1 {",
			"  static final $1 _singleton = $1._internal();",
			"  factory $1() => _singleton;",
			"  $1._internal();",
			"}"
		],
		"description": "Creates a singleton manager."
	}
```

#### 'Wrap with MSSB' Snippet

I'd like to add 'Wrap with MSSB' to the refactor menu, but that is difficult, so for now I've been using this:

To make an MSSB, first do a 'Refactor / Wrap with Widget', then select:
```
widget(
    child: 
```
and then type the snippet: `mssb`.