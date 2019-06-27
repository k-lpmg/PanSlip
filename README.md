# PanSlip
[![Build Status](https://travis-ci.org/k-lpmg/PanSlip.svg?branch=master)](https://travis-ci.org/k-lpmg/PanSlip)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![Cocoapods](https://img.shields.io/cocoapods/v/PanSlip.svg?style=flat)](https://cocoapods.org/pods/PanSlip)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/k-lpmg/PanSlip/blob/master/LICENSE)

Use PanGesture to dismiss view on UIViewController and UIView.

## PanSlip to UIViewController
left to right | right to left | top to bottom | bottom to top
--- | :---: | --- | :---:
<img src="https://user-images.githubusercontent.com/15151687/59292203-8df41c00-8cb7-11e9-82ba-2a8dd3116c24.gif" width="155" height="330"> | <img src="https://user-images.githubusercontent.com/15151687/59292205-8fbddf80-8cb7-11e9-8f5d-27580041a429.gif" width="155" height="330"> | <img src="https://user-images.githubusercontent.com/15151687/59292211-9187a300-8cb7-11e9-83e2-2f51b519cbb5.gif" width="155" height="330"> | <img src="https://user-images.githubusercontent.com/15151687/59292214-93e9fd00-8cb7-11e9-9378-2cbe460de4d7.gif" width="155" height="330">

## PanSlip to UIView
left to right | right to left | top to bottom | bottom to top
--- | :---: | --- | :---:
<img src="https://user-images.githubusercontent.com/15151687/59292218-977d8400-8cb7-11e9-807f-5d5d096be483.gif" width="155" height="330"> | <img src="https://user-images.githubusercontent.com/15151687/59292220-9a787480-8cb7-11e9-9bd4-27a18d555b60.gif" width="155" height="330"> | <img src="https://user-images.githubusercontent.com/15151687/59292224-9cdace80-8cb7-11e9-8bc1-8401d9b794eb.gif" width="155" height="330"> | <img src="https://user-images.githubusercontent.com/15151687/59292228-a06e5580-8cb7-11e9-9b4e-8262ac573ac0.gif" width="155" height="330">

## Usage

#### Enable
```swift
// UIViewController
let viewController = UIViewController()
viewController.ps.enable(slipDirection: .topToBottom) {
    // TODO completion when UIViewController dismissed
}

// UIView
let view = UIView()
view.ps.enable(slipDirection: .topToBottom) {
    // TODO completion when UIView dismissed
}
```

#### Disable
```swift
// UIViewController
let viewController = UIViewController()
viewController.ps.disable()

// UIView
let view = UIView()
view.ps.disable()
```

#### Manual slip
```swift
// UIViewController
let viewController = UIViewController()
viewController.ps.slip(animated: true)

// UIView
let view = UIView()
view.ps.slip(animated: true)
```

#### Set percentThreshold
```swift
// UIViewController
extension UIViewController: PanSlipBehavior {
    public var percentThreshold: CGFloat? {
        return 0.2
    }
}

// UIView
extension UIView: PanSlipBehavior {
    public var percentThreshold: CGFloat? {
        return 0.2
    }
}
```

## Installation

#### CocoaPods (iOS 8+)

```ruby
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'PanSlip'
end
```

#### Carthage (iOS 8+)

```ruby
github "k-lpmg/PanSlip"
```

## LICENSE

These works are available under the MIT license. See the [LICENSE][license] file
for more info.

[license]: LICENSE
