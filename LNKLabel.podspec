#
# Be sure to run `pod lib lint LNKLabel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LNKLabel'
  s.version          = '0.2.0'
  s.summary          = 'Inputed link text automatic appending attribute.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Inputed link text automatic appending attribute.
supporting links
- URL
- Phone number
- E-mail address
                       DESC

  s.homepage         = 'https://github.com/asashin227/LNKLabel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'asashin227' => 'asa.shin.asa@gmail.com' }
  s.source           = { :git => 'https://github.com/asashin227/LNKLabel.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'LNKLabel/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LNKLabel' => ['LNKLabel/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
