# MSBBarChart
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![Version](https://img.shields.io/cocoapods/v/MSBBarChart.svg?style=flat)](http://cocoapods.org/pods/MSBBarChart)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/komaji/GradientAnimationView/blob/master/LICENSE)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

<h3>MSBBarChart is an easy to use bar chart library for iOS.
</h3>

<img width=280 src="https://user-images.githubusercontent.com/509448/73722607-38024600-476a-11ea-8806-cc4a9245ffd8.gif">

## Usage

![スクリーンショット 2020-02-04 16 38 16](https://user-images.githubusercontent.com/509448/73723618-caa3e480-476c-11ea-8eb2-4e0424d6820f.png)

### Enable to manage the display of the label above bar
if you remove label above bar

```
barChart.isHiddenLabelAboveBar = true
```


## Installation

### CocoaPods

MSBBarChart is available through CocoaPods. To install it, simply add the following line to your Podfile:

```
pod 'MSBBarChart'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager for Cocoa application.

``` bash
$ brew update
$ brew install carthage
```

To integrate MSBBarChart into your Xcode project using Carthage, specify it in your `Cartfile`:

``` ogdl
github "misyobun/MSBBarChart"
```

Then, run the following command to build the MetaRod framework:

``` bash
$ carthage update --platform iOS
```

You will then have to drag MSBBarChart.framework yourself into your project from the Carthage/Build folder.
