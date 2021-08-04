# Mac SwiftUI Toolbar Memory Leak Demo

On macOS, SwiftUI's APIs for adding toolbar items to a window have (at least) two bugs around view recreation that lead to memory leaks and increased CPU pressure over time.

## Issue #1: `ToolbarItem` always creates an additional, "ghost" copy of the view it contains

For example,

```swift
Color.clear
    .toolbar {
        ToolbarItem {
            Color.red
                .onAppear { print("This will be printed twice.") }
        }
    }
```

will print "This will be printed twice" twice. `ToolbarItem` creates an additional copy of `Color.red`. This ghost copy is fully functional, reacts to state changes (assuming it hosts something within itself that changes state), and is not destroyed until its parent `.toolbar()` leaves the view hierarchy. This is true even if your view hierarchy is complete static, with nothing to trigger a state change.

## Issue #2: `ToolbarItem` creates an additional ghost copy of the view it contains every single time state changes

Pretend you have some state:

```swift
@State var counter = 0
```

...and a toolbar item in your view, that updates that state whenever every so often:

```swift
Color.clear
    .toolbar {
        ToolbarItem {
            Text("\(counter)")
                .onAppear { print("This will be printed every change of counter.") }
        }
    }
    .onAppear {
        //  Start a timer that updates counter += 1 every so often
    }
```

that `onAppear()` will be printed every single time `counter` changes. The same issues outlined in the previous issue are true here.

## Closing

Both of these issues are demonstrated in the sample project in this repo.

I've filed this bug under [FB9453009](https://openradar.appspot.com/radar?id=5011018224762880).