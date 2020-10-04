## [0.1.4] - 2020-10-03

* Add derived StreamState.combined() constructor.  See https://github.com/phimath/stream_state/issues/3


## [0.1.3] - 2020-08-17

* Add update() method, but didn't recommend in readme.  See discussion: https://github.com/phimath/stream_state/issues/1

## [0.1.2] - 2020-08-17

* Explain `forceResetPersist` in readme


## [0.1.1] - 2020-08-17

* Add ability to persist the state of custom classes, by providing the `serialize` and `deserialize` functions
* Update `persist_state_main.dart` example and readme to show how to do this.

## [0.1.0] - 2020-08-16

* Conditionally import hive to fix pub.dev web support detection

## [0.0.8] - 2020-08-16

* Added easy automatic state persistence

## [0.0.7] - 2020-08-6

* Collect and cancel MSSB subscriptions

## [0.0.6] - 2020-08-6

* Add and explain forceUpdate() to handle indirect modification of state.
* Add `MSSB` alias because `MultiStreamStateBuilder` is long to type

## [0.0.5] - 2020-08-2

* Clean up readme with clearer and simpler examples.


## [0.0.4] - 2020-08-1

* Add `MultiStreamStateBuilder` and update docs to only show this use.  It makes it easy to use many `StreamState` objects without the need for nesting.


## [0.0.3] - 2020-08-1

* Fix github link

## [0.0.2] - 2020-08-1

* Better readme


## [0.0.1] - 2020-08-1

* Initial release
