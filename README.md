# BFGAlertController

An appearance-customizable version of `UIAlertController` (Alert and Action Sheet). API should be very similar to `UIAlertController` with added methods to handle appearance customization. More thorough documentation is forthcoming, but you can look at the example project or the library for more detail.

## Installation

### CocoaPods

Will eventually be available through CocoaPods, but for now, you can import it as a development pod (there is a `BFGAlertController.podspec`). Just download and add it locally. `BFGAlertController` is written in Swift (2.2) so you will likely need to add framework support. The class should also be available to Objective-C code.

### Carthage

The latest version (0.2.0) has been updated to build as a shared framework and you can include it in your own projects via Carthage.

`````ruby
github "blackfog/BFGAlertController" ~> 0.2.0
`````

## Known Issues

Feel free to report or fix and submit a pull request if you find any.

- The appearance API needs work
- Cannot currently hide the Cancel button on an Action Sheet displayed in a popover

## License

MIT. Have at it.
