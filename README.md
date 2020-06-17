# MSBBarChart
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![Version](https://img.shields.io/cocoapods/v/MSBBarChart.svg?style=flat)](http://cocoapods.org/pods/MSBBarChart)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/komaji/GradientAnimationView/blob/master/LICENSE)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

<h3>MSBBarChart is an easy to use bar chart library for iOS.
</h3>

<img width=280 src="https://user-images.githubusercontent.com/509448/84864930-5f6f0500-b0b2-11ea-8350-d0aac3925ac5.gif">

## Usage

![スクリーンショット 2020-02-04 16 38 16](https://user-images.githubusercontent.com/509448/73723618-caa3e480-476c-11ea-8eb2-4e0424d6820f.png)

### if you want to hide label above bar

```
barChart.setOptions([.isHiddenLabelAboveBar(true)])
```

### if you want to hide labels and lines

```
barChart.setOptions([.isHiddenExceptBars(true)])
```

### if you want to add some gradient to your bars 

```
barChart.setOptions([.isGradientBar(true)])

// Instead of assignmentOfColor 
barChart.assignmentOfGradient = [0.0..<0.25: [#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1),#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)], 0.25..<0.50: [#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)], 0.50..<0.75:[#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)], 0.75..<1.0: [#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]]

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
