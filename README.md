# PanSlip
![Swift](https://img.shields.io/badge/Swift-4.2-orange.svg)
[![Cocoapods](https://img.shields.io/cocoapods/v/PanSlip.svg?style=flat)](https://cocoapods.org/pods/PanSlip)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/k-lpmg/PanSlip/blob/master/LICENSE)

Use PanGesture to dismiss view on UIViewController and UIView.

## PanSlip to UIViewController
left to right | right to left | top to bottom | bottom to top
--- | :---: | --- | :---:
<img src="https://user-images.githubusercontent.com/15151687/59284589-74e36f00-8ca7-11e9-99a9-62f7ff09176a.gif" width="155" height="330"> | <img src="https://user-images.githubusercontent.com/15151687/59284597-76ad3280-8ca7-11e9-8899-60dcd266c99e.gif" width="155" height="330"> | <img src="https://user-images.githubusercontent.com/15151687/59284604-790f8c80-8ca7-11e9-8b5b-514e5d2f69b3.gif" width="155" height="330"> | <img src="https://user-images.githubusercontent.com/15151687/59284614-7d3baa00-8ca7-11e9-8b6c-fa581be6aca8.gif" width="155" height="330">

## PanSlip to UIView
left to right | right to left | top to bottom | bottom to top
--- | :---: | --- | :---:
<img src="https://user-images.githubusercontent.com/15151687/59284636-86c51200-8ca7-11e9-9099-2ee9f4db7e30.gif" width="155" height="330"> | <img src="https://user-images.githubusercontent.com/15151687/59284638-888ed580-8ca7-11e9-86da-fa7e0cf07d10.gif" width="155" height="330"> | <img src="https://user-images.githubusercontent.com/15151687/59284652-90e71080-8ca7-11e9-8a26-d6c47f49381e.gif" width="155" height="330"> | <img src="https://user-images.githubusercontent.com/15151687/59284655-93496a80-8ca7-11e9-9da6-40e6e85d5d82.gif" width="155" height="330">

## Usage

#### Enable
```swift
// UIViewController
let viewController = UIViewController()
viewController.enablePanSlip(direction: .topToBottom) {
    // TODO completion when UIViewController dismissed
}

// UIView
let view = UIView()
view.enablePanSlip(direction: .topToBottom) {
    // TODO completion when UIView dismissed
}
```

#### Disable
```swift
// UIViewController
let viewController = UIViewController()
viewController.disablePanSlip()

// UIView
let view = UIView()
view.disablePanSlip()
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
