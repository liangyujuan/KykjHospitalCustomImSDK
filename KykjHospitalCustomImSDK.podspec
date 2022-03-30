#
# Be sure to run `pod lib lint KykjHospitalCustomImSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KykjHospitalCustomImSDK'
  s.version          = '0.0.5'
  s.summary          = 'KykjHospitalCustomImSDK is audio frequency and video sdk'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'KykjHospitalCustomImSDK is a description'

  s.homepage         = 'https://github.com/liangyujuan/KykjHospitalCustomImSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liangyujuan' => '18730231873@163.com' }
  s.source           = { :git => 'https://github.com/liangyujuan/KykjHospitalCustomImSDK.git', :tag => '0.0.5'}
#s.source           = { :git => '/Users/liangyujuan/Documents/KykjHospitalCustomImSDK', :tag => '1.0.0'}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'KykjHospitalCustomImSDK/Classes/**/*.{h}'
  
   s.resource_bundles = {
     'KykjHospitalCustomImSDK' => ['KykjHospitalCustomImSDK/Assets/*.{png,xib}']
   }


#s.resource_bundles = {
#  'KykjHospitalCustomImSDK' => ['KykjHospitalCustomImSDK/KykjHospitalCustomImSDK.bundle']
#}

 s.public_header_files = 'KykjHospitalCustomImSDK/Classes/Header/*.h'

#   s.public_header_files = 'Pod/Classes/**/*.h'
   
   s.frameworks = 'UIKit', 'AVFoundation','Foundation'
   s.static_framework = true
   
   s.dependency 'RongCloudIM/IMLib', '~> 2.10.4'
   s.dependency 'RongCloudIM/IMKit', '~> 2.10.4'
   s.dependency 'TXLiteAVSDK_TRTC', '~> 8.3.9901'
   s.dependency 'TXIMSDK_iOS'

#   s.dependency 'Masonry', '~>1.1.0'
#   s.dependency 'AFNetworking', '~>4.0.1'
#   s.dependency 'MBProgressHUD', '~>1.1.0'
#   s.dependency 'MJRefresh', '~>3.2.0'
#   s.dependency 'IQKeyboardManager', '~>6.3.0'
#   s.dependency 'SDWebImage', '~>5.12.3'

s.dependency 'Masonry'
s.dependency 'AFNetworking'
s.dependency 'MBProgressHUD'
s.dependency 'MJRefresh'
s.dependency 'IQKeyboardManager'
s.dependency 'SDWebImage'

end
