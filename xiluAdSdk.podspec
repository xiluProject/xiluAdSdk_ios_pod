#
# Be sure to run `pod lib lint ADXiluSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'xiluAdSdk'
  s.version          = '1.0.7'
  s.summary          = 'ADXilu iOS SDK - 广告聚合SDK'
  s.module_name  = "ADXiluSDK"
  s.description      = <<-DESC
    ADXilu iOS SDK 是一个广告聚合SDK，支持多个主流广告平台，提供统一的广告接口。
  DESC
  s.homepage         = 'https://github.com/xiluProject/xiluAdSdk_ios_pod'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zyn' => 'zyn@163.com' }
  s.source           = { :git => 'https://github.com/xiluProject/xiluAdSdk_ios_pod.git', :tag => s.version.to_s }

  s.platform    = :ios, '12.2'
  s.ios.deployment_target = '12.2'
  s.frameworks = "UIKit", "Foundation", "AVFoundation", "CoreLocation", "SystemConfiguration", "AdSupport", "CoreTelephony"
 
  s.swift_version = "5.0"
  s.vendored_frameworks = "ADXiluSDK/*.xcframework"
  # Swift 库必须开启模块化
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES', # 核心：生成模块，否则其他项目无法导入
    'SWIFT_VERSION' => '5.0'
  }
  s.dependency  'CryptoSwift'
  s.dependency   'GDTMobSDK', '4.15.65'
  s.dependency  'BeiZiSDK-iOS', '4.90.7.0'
  s.dependency  'MSMobAdSDK/MS', '2.7.7.3'
  s.exclude_files = "ADXiluSDK/Classes/Tool/*.md" # 排除所有 md 文件
end
