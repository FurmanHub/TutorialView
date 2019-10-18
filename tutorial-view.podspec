#
#  Be sure to run `pod spec lint tutorial-view.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|


  spec.name         = "tutorial-view"
  spec.version      = "0.0.2"
  spec.summary      = "Tutorial View"

  spec.description  = "Cleveroad Tutorial View"

  spec.homepage     = "https://github.com/FurmanHub/TutorialView"

  spec.license      = "MIT"
  #spec.license      = { :type => 'MIT', :file => 'LICENSE.md' }

  spec.author             = { "fedorvolchkovcr" => "fedor.volchkov.cr@gmail.com" }

   spec.platform     = :ios, '12.4'
   spec.swift_versions = '5.0'

  spec.source       = { :git => "https://github.com/FurmanHub/TutorialView.git", :branch => "master", :tag => "#{spec.version}" }


  spec.source_files = 'TutorialView/*.swift'

end
