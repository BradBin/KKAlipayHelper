#
# Be sure to run `pod lib lint KKAlipayHelper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KKAlipayHelper'
  s.version          = '1.0.0'
  s.summary          = 'KKUnionPayHelper is a Tool for AlipaySDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  KKUnionPayHelper is a Tool for AlipaySDK,Convenient and Fast Inheritance of Payment Function.
                       DESC

  s.homepage         = 'https://github.com/BradBin/KKAlipayHelper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BradBin' => 'youbin@kkorange.com' }
  s.source           = { :git => 'https://github.com/BradBin/KKAlipayHelper.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'KKAlipayHelper/Classes/**/*.{h,m}'
  
  # s.resource_bundles = {
  #   'KKAlipayHelper' => ['KKAlipayHelper/Assets/*.png']
  # }

  s.public_header_files = 'KKAlipayHelper/Classes/**/*.h'
  s.requires_arc = true
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'AlipaySDK-iOS', '~> 15.5.9'
end
