#
#  Be sure to run `pod spec lint DCPickerRecord.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "DCPickerRecord"
  s.version      = "0.1.0"
  s.summary      = "Quick recoder for UIPickerView."

  s.homepage     = "https://github.com/qtdc1229/DCPickerRecord"

  s.license      = { :type => "MIT", 
                     :file => "LICENSE" }

  s.author             = { "qtdc1229" => "dc328466990@163.com" }
  # s.social_media_url   = "http://twitter.com/qtdc1229"

  s.platform     = :ios
  s.ios.deployment_target = '6.0'

  s.source       = { :git => "https://github.com/qtdc1229/DCPickerRecord.git", :tag => 'v0.1.0' }

  s.source_files = "DCPickerRecord/DCPickerRecord/*.{h,m}", "DCPickerRecord/DynamicDelegate/*.{h,m}"
  s.public_header_files = "DCPickerRecord/DCPickerRecord/*.{h}", "DCPickerRecord/DynamicDelegate/*.{h}"

  s.frameworks   = "Foundation", "UIKit"

  s.requires_arc = true

end
