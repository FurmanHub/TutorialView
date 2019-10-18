#
#  Be sure to run `pod spec lint tutorial-view.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|


  spec.name         = "tutorial-view"
  spec.version      = "0.0.1"
  spec.summary      = "Tutorial View"

  spec.description  = "Cleveroad Tutorial View"

  spec.homepage     = "https://github.com/maxkoriakincr/Tutorial-View"

  spec.license      = "MIT"
  #spec.license      = { :type => 'MIT', :file => 'LICENSE.md' }

  spec.author             = { "maxkoriakincr" => "maxym.koriakin.cr@gmail.com" }

   spec.platform     = :ios, '12.4'
   spec.swift_versions = '5.0'

  spec.source       = { :git => "https://github.com/maxkoriakincr/Tutorial-View.git", :branch => "master", :tag => "#{spec.version}" }


  spec.source_files = 'TutorialView/*.swift'
  #spec.public_header_files = "Classes/**/*.h"

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # spec.framework  = 'UIKit'
  # spec.frameworks = 'UIKit', 'QuartzCore', 'Foundation'

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
