#
#  Be sure to run `pod spec lint MetaRod.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "MSBBarChart"
  spec.version      = "1.0.7"
  spec.summary      = "MSBBarChart is an easy to use bar chart library for iOS"
  spec.homepage     = "https://github.com/misyobun/MSBBarChart"
  spec.screenshots  = "https://user-images.githubusercontent.com/509448/73722607-38024600-476a-11ea-8806-cc4a9245ffd8.gif"
  spec.license      = "MIT"
  spec.author    	= "misyobun"
  spec.social_media_url   = "https://twitter.com/misyobun"
  spec.platform     = :ios
  spec.requires_arc = true
  spec.swift_versions = ['5.0']
  spec.source           = { :git => "https://github.com/misyobun/MSBBarChart.git", :tag => spec.version.to_s }
  spec.source_files  = "MSBBarChart/Sources/**/*"
  spec.ios.deployment_target = '13.0'
end
