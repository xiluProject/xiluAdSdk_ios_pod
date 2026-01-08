# xiluAdSdk - 聚合广告SDK

xiluAdSdk是一个支持多平台广告聚合的iOS SDK，提供统一的API接口，支持MSMobAdSDK和BeiZiSDK的集成。支持Objective-C和Swift/SwiftUI项目。

## 特性

- **多平台支持**: 集成MSMobAdSDK和BeiZiSDK
- **iOS兼容**: 最低支持iOS 12.2，兼容新老系统API
- **组件化架构**: 模块化设计，易于扩展和维护
- **统一接口**: 提供一致的API，简化多平台广告管理
- **多语言支持**: 支持Objective-C和Swift
- **完整回调**: 提供加载、展示、点击、关闭等完整事件回调
- **易于集成**: 通过CocoaPods简单集成

## 支持的广告类型

- **横幅广告** (Banner Ad)
- **插屏广告** (Interstitial Ad)  
- **激励视频广告** (Reward Video Ad)
- **开屏广告** (Splash Ad)
- **信息流广告** (Native Ad)

## 支持的广告平台

- **MSMobAdSDK**: 美数广告平台
- **BeiZiSDK**: 倍孜广告平台
-  **GDTMobSDK**: 优量汇广告平台
- **自动选择**: 根据配置自动选择最优平台

## 系统要求

- iOS 12.2+
- Xcode 12.0+
- Swift 5.0+
- CocoaPods 1.10.0+

## 安装

### 使用CocoaPods

1. 在您的`Podfile`中添加：

```ruby
platform :ios, '12.2'

target 'YourApp' do
  use_frameworks!
  
  # 使用远程版本
  pod 'xiluAdSdk', '~> 1.0.7'
end
```

2. 运行安装命令：

```bash
pod install
```

3. 打开生成的`.xcworkspace`文件

## 快速开始

### 1. 初始化SDK

#### Objective-C

```objc
#import <ADXiluSDK/ADXiluSDK.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[ADXiluSDKManager shared] initializeWithAppId:@"your_app_id" 
                                     debug:YES 
                                 completion:^(BOOL success, NSString * _Nullable error) {
        if (success) {
            NSLog(@"ADXiluSDK initialized successfully");
        } else {
            NSLog(@"ADXiluSDK initialization failed: %@", error);
        }
    }];
    return YES;
}
```

#### Swift

```swift
import ADXiluSDK

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    ADXiluSDKManager.shared.initialize(appId: "your_app_id", debug: true) { success, error in
        if success {
            print("ADXiluSDKManager initialized successfully")
        } else {
            print("ADXiluSDKManager initialization failed: \(error ?? "Unknown error")")
        }
    }
    return true
}
```

### 2. 加载和展示广告

#### 横幅广告

#### Objective-C

```objc
#import <ADXiluSDK/ADXiluSDK.h>

- (void)loadBannerAd {
    if (![ADXiluSDKManager shared].isInitialized) {
        [self showAlertWithTitle:@"错误" message:@"SDK未初始化"];
        return;
    }
    
    // 释放之前的广告
    self.bannerAd = nil;
    
    // 创建Banner广告
    ADXiluAdSize *adSize = [[ADXiluAdSize alloc] initWithWidth:CGRectGetWidth([UIScreen mainScreen].bounds) height:60];
    self.bannerAd = [[ADXiluBannerAd alloc] initWithAdPosId:@"your_interstitial_ad_pos_id" adSize:adSize];
    self.bannerAd.showCloseBtn = YES;
    self.bannerAd.containerView = self.containerView;
    self.bannerAd.nativeViewController = self;
    self.bannerAd.delegate = self;
    self.bannerAd.autoRefreshInterval = 5;
    
    self.statusLabel.text = @"状态：正在加载...";
    self.statusLabel.textColor = [UIColor systemOrangeColor];
    
    [self.bannerAd loadAd];
}
// 实现代理方法
- (void)xilu_AdDidReceive:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    NSLog(@"Banner广告加载成功");
}

- (void)xilu_AdDidFail:(ADXiluBaseAd *)xiluAd error:(ADXiluError *)error {
    NSLog(@"Banner广告加载失败： %@", error);
}
- (void)xilu_AdDidClick:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    NSLog(@"Banner广告被点击");
}
- (void)xilu_AdDidClose:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    NSLog(@"Banner广告被关闭");
}
```

#### Swift
```swift
import ADXiluSDK

class BannerAdViewController: UIViewController {
    private var bannerAd: ADXiluBannerAd?
    private var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func loadBannerAd() {
        guard ADXiluSDKManager.shared.isInitialized else {
            print("SDK未初始化")
            return
        }
        
        // 创建Banner广告
        let adSize = ADXiluAdSize(width: UIScreen.main.bounds.width, height: 60)
        bannerAd = ADXiluBannerAd(adPosId: "your_banner_ad_pos_id", adSize: adSize)
        bannerAd?.showCloseBtn = true
        bannerAd?.containerView = containerView
        bannerAd?.nativeViewController = self
        bannerAd?.delegate = self
        bannerAd?.autoRefreshInterval = 5
        
        bannerAd?.loadAd()
    }
}

// 实现代理方法
extension BannerAdViewController: ADXiluBaseAdDelegate {
    func xilu_AdDidReceive(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        print("Banner广告加载成功 - \(adInfo.platform.name)")
    }
    
    func xilu_AdDidFail(_ xiluAd: ADXiluBaseAd, error: ADXiluError) {
        print("Banner广告加载失败: \(error.message)")
    }
    
    func xilu_AdDidClick(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        print("Banner广告被点击")
    }
    
    func xilu_AdDidClose(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        print("Banner广告已关闭")
    }
}
```

#### 插屏广告
#### Objective-C

```objc
#import <ADXiluSDK/ADXiluSDK.h>

- (void)loadInterstitialAd {
    if (![ADXiluSDKManager shared].isInitialized) {
        [self showAlertWithTitle:@"错误" message:@"SDK未初始化"];
        return;
    }
    _interstitialAd = [[ADXiluInterstitialAd alloc] initWithAdPosId:@"your_interstitial_ad_pos_id"
                                                             adSize:[ADXiluAdSize screenSize]
                                                             rootVC:self];
    _interstitialAd.delegate = self;
    [self.interstitialAd loadAd];
}
// 实现代理方法
- (void)xilu_AdDidReceive:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    NSLog(@"插屏广告加载成功");
    // 可以展示广告
    [(ADXiluInterstitialAd *)xiluAd showAdFrom:self];
}

- (void)xilu_AdDidFail:(ADXiluBaseAd *)xiluAd error:(ADXiluError *)error {
    NSLog(@"插屏广告加载失败： %@", error);
}
- (void)xilu_AdDidClick:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    NSLog(@"插屏广告被点击");
}
- (void)xilu_AdDidClose:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    NSLog(@"插屏广告被关闭");
}
```

#### Swift
```swift
class InterstitialAdViewController: UIViewController {
    private var interstitialAd: ADXiluInterstitialAd?
    
    private func loadInterstitialAd() {
        guard ADXiluSDKManager.shared.isInitialized else {
            print("SDK未初始化")
            return
        }
        
        // 创建插屏广告
        let adSize = ADXiluAdSize(width: UIScreen.main.bounds.width, height: 300)
        interstitialAd = ADXiluInterstitialAd(adPosId: "your_interstitial_ad_pos_id", 
                                             adSize: adSize, 
                                             rootVC: self)
        interstitialAd?.delegate = self
        
        interstitialAd?.loadAd()
    }
    
    private func showInterstitialAd() {
        interstitialAd?.showAd(from: self)
    }
}
// 实现代理方法
extension InterstitialAdViewController: ADXiluBaseAdDelegate {
    func xilu_AdDidReceive(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        print("插屏广告加载成功")
        // 可以展示广告
        showInterstitialAd()
    }
    
    func xilu_AdDidFail(_ xiluAd: ADXiluBaseAd, error: ADXiluError) {
        print("插屏广告加载失败: \(error.message)")
    }
    
    func xilu_AdDidClose(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        print("插屏广告已关闭")
    }
}
```

#### 激励视频广告
#### Objective-C

```objc
#import <ADXiluSDK/ADXiluSDK.h>

- (void)loadRewardVodAd {
    if (![ADXiluSDKManager.shared isInitialized]) {
        [self showAlertWithTitle:@"错误" message:@"SDK未初始化"];
        return;
    }
    
    // 释放之前的广告
    [self.rewardVodAd p_release];
    
    // 创建激励视频广告
    self.rewardVodAd = [[ADXiluRewardVodAd alloc] initWithAdPosId:@"your_interstitial_ad_pos_id"];
    self.rewardVodAd.delegate = self;
    self.rewardVodAd.videoDelegate = self;
    self.rewardVodAd.isMuted = NO;
    
    self.statusLabel.text = @"状态：正在加载...";
    self.statusLabel.textColor = [UIColor systemOrangeColor];
    
    [self.rewardVodAd loadAd];
}
// 实现代理方法
//ADXiluBaseAdDelegate
- (void)xilu_AdDidReceive:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    NSLog(@"激励视频加载成功");
    // 可以展示广告
    [self.rewardVodAd showAdFrom:self];
}

- (void)xilu_AdDidFail:(ADXiluBaseAd *)xiluAd error:(ADXiluError *)error {
    NSLog(@"激励视频加载失败： %@", error);
}
//ADXiluRewardVodAdDelegate
- (void)xilu_AdDidReward:(ADXiluBaseAd *)rewardVodAd adInfo:(ADXiluAdInfo *)adInfo {
    NSLog(@"获得奖励");
}

- (void)xilu_AdVideoDidComplete:(ADXiluBaseAd *)rewardVodAd adInfo:(ADXiluAdInfo *)adInfo{
    NSLog("视频播放完成");
}
```

#### Swift
```swift
class RewardVodAdViewController: UIViewController {
    private var rewardVodAd: ADXiluRewardVodAd?
    
    private func loadRewardVodAd() {
        guard ADXiluSDKManager.shared.isInitialized else {
            print("SDK未初始化")
            return
        }
        
        // 创建激励视频广告
        rewardVodAd = ADXiluRewardVodAd(adPosId: "your_reward_vod_ad_pos_id")
        rewardVodAd?.delegate = self
        rewardVodAd?.videoDelegate = self
        rewardVodAd?.isMuted = false
        
        rewardVodAd?.loadAd()
    }
    
    private func showRewardVodAd() {
        rewardVodAd?.showAd(from: self)
    }
}
// 实现代理方法
extension RewardVodAdViewController: ADXiluBaseAdDelegate {
    func xilu_AdDidReceive(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        print("激励视频广告加载成功")
        // 可以展示广告
        showRewardVodAd()
    }
    
    func xilu_AdDidFail(_ xiluAd: ADXiluBaseAd, error: ADXiluError) {
        print("激励视频广告加载失败: \(error.message)")
    }
}

extension RewardVodAdViewController: ADXiluRewardVodAdDelegate {
    func xilu_AdDidReward(_ rewardVodAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        print("获得奖励: \(adInfo.rewardAmount) \(adInfo.rewardName)")
    }
    
    func xilu_AdVideoDidComplete(_ rewardVodAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        print("视频播放完成")
    }
}
```

#### 开屏广告
#### Objective-C

```objc
#import <ADXiluSDK/ADXiluSDK.h>

- (void)loadSplashAd {
    if (![ADXiluSDKManager.shared isInitialized]) {
        [self showAlertWithTitle:@"错误" message:@"SDK未初始化"];
        return;
    }
    
    // 释放之前的广告
    [self.splashAd p_release];
    
    // 创建开屏广告
    ADXiluAdSize *adSize = [[ADXiluAdSize alloc] initWithWidth:[UIScreen mainScreen].bounds.size.width height:300];
    self.splashAd = [[ADXiluSplashAd alloc] initWithAdPosId:@"your_interstitial_ad_pos_id" style:ADXiluSplashAdStyleHalfScreen adSize:adSize];
    self.splashAd.bottomView = self.bottomView;
    self.splashAd.delegate = self;
    self.splashAd.countdownDuration = 5.0;
    
    self.statusLabel.text = @"状态：正在加载...";
    self.statusLabel.textColor = [UIColor systemOrangeColor];
    self.loadButton.enabled = NO;
    
    [self.splashAd loadAd];
    self.showButton.hidden = YES;
}
// 实现代理方法
- (void)xilu_AdDidReceive:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    NSLog("开屏广告加载成功");
    // 可以展示广告
    [self.splashAd showAdIn:self.containerView];
}


- (void)xilu_AdDidFail:(ADXiluBaseAd *)xiluAd error:(ADXiluError *)error {
    NSLog(@"开屏广告加载失败: %@", error);
}

- (void)xilu_AdTick:(ADXiluBaseAd *)xiluAd remainingTime:(NSTimeInterval)remainingTime {
    NSLog(@"倒计时: %f", remainingTime);
}
```

#### Swift
```swift
class SplashAdViewController: UIViewController {
    private var splashAd: ADXiluSplashAd?
    
    private func loadSplashAd() {
        guard ADXiluSDKManager.shared.isInitialized else {
            print("SDK未初始化")
            return
        }
        
        // 创建开屏广告
        let adSize = ADXiluAdSize(width: UIScreen.main.bounds.width, height: 300)
        splashAd = ADXiluSplashAd(adPosId: "your_splash_ad_pos_id", 
                                 style: .halfScreen, 
                                 adSize: adSize)
        splashAd?.delegate = self
        splashAd?.countdownDuration = 5.0
        
        splashAd?.loadAd()
    }
    
    private func showSplashAd() {
        splashAd?.showAd()
    }
}

extension SplashAdViewController: ADXiluBaseAdDelegate {
    func xilu_AdDidReceive(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        print("开屏广告加载成功")
        // 可以展示广告
        showSplashAd()
    }
    
    func xilu_AdDidFail(_ xiluAd: ADXiluBaseAd, error: ADXiluError) {
        print("开屏广告加载失败: \(error.message)")
    }
    
    func xilu_AdTick(_ xiluAd: ADXiluBaseAd, remainingTime: TimeInterval) {
        print("倒计时: \(Int(remainingTime))s")
    }
}
```

#### 信息流广告
#### Objective-C

```objc
#import <ADXiluSDK/ADXiluSDK.h>

- (void)loadNativeAd {
    _nativeAd = [[ADXiluNativeAd alloc] initWithAdPosId:@"your_interstitial_ad_pos_id" adSize:[ADXiluAdSize screenSize] count:ad_count];
    _nativeAd.delegate = self;
    _nativeAd.containerView = nil;
    _nativeAd.isTemplate = false;//(信息流模板广告为true,信息流自渲染广告为false)
    [self.nativeAd loadAd];
}


// 实现代理方法
- (void)xilu_AdDidReceiveMuti:(ADXiluBaseAd *)xiluAd adInfos:(NSArray<ADXiluAdInfo *> *)adInfos {
    NSLog(@"信息流广告加载成功：%@", adInfos);
      for (ADXiluAdInfo *adInfo in adInfos) {
        UIView *adTemplateView = adInfo.extraData[@"nativeAdView"];
        MSNativeFeedAdModel *adModel = adInfo.extraData[@"nativeAdData"];

       
        if (adTemplateView) {
                //模板广告
            [self.adContainerView addArrangedSubview:adTemplateView];//替换成广告容器视图
        } else if (adModel) {
            //自渲染广告，取nativeAdData
            UIView *adView = [self createAdView:adModel];
            [adView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAdDetail)]];
            [self.adContainerView addArrangedSubview:adView];
        }
    }

    
}


- (void)xilu_AdDidFail:(ADXiluBaseAd *)xiluAd error:(ADXiluError *)error {
    NSLog(@"信息流广告加载失败: %@", error);
}

```

#### Swift
```swift
class NativeRenderAdViewController: UIViewController {
    
    @objc private func loadAd() {
        guard ADXiluSDKManager.shared.isInitialized else {
            showAlert(title: "错误", message: "SDK未初始化")
            return
        }
        
        // 释放之前的广告
        nativeAd?.p_release()
        
        // 创建信息流广告
        let adSize = ADXiluAdSize(width: UIScreen.main.bounds.width, height: 300)
        nativeAd = ADXiluNativeAd(adPosId: "your_interstitial_ad_pos_id", adSize: adSize, count:ad_count)
        nativeAd?.isTemplate = false (信息流模板广告为true,信息流自渲染广告为false)
        nativeAd?.nativeViewController = self
        nativeAd?.delegate = self
        
        nativeAd?.loadAd()
    }
}
// 实现代理方法
extension NativeRenderAdViewController: ADXiluBaseAdDelegate {
    func xilu_AdDidReceiveMuti(_ xiluAd: ADXiluBaseAd, adInfos: [ADXiluAdInfo]) {
        print("信息流广告加载成功")
        
        for adInfo in adInfos {
            if let adView = adInfo.extraData["nativeAdView"] as? UIView {
            //模板广告
                nativeAds.append(adView)
            }
            if let model = adInfo.extraData["nativeAdData"] as? MSNativeFeedAdModel {
                //自渲染广告
                if model.adMaterialMeta?.metaCreativeType() != MSCreativeType.video {
                    let adView:MSNativeSimpleCustomAdView = MSNativeSimpleCustomAdView()
                    adView.delegate = self
                    adView.presentVc = self
                    adView.loadFeedAdMeta(feedAdMeta: model.adMaterialMeta!)
                    adView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: adView.calculateAdHeightWithFeedAdMeta(feedAd: model.adMaterialMeta!))
                    nativeAds.append(adView)
                } else {
                    let adView: MSNativeSimpleCustomVideoAdView = MSNativeSimpleCustomVideoAdView()
                    adView.delegate = self
                    adView.presentVc = self
                    adView.loadFeedAdMeta(feedAdMeta: model.adMaterialMeta!)
                    adView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: adView.calculateAdHeightWithFeedAdMeta(feedAd: model.adMaterialMeta!))
                    nativeAds.append(adView)
                }
            }
        }
        displayAd()
    }
    func xilu_AdDidFail(_ xiluAd: ADXiluBaseAd, error: ADXiluError) {
        print("信息流加载失败")
        
    }
}
```

## API参考

### 核心类

#### ADXiluSDK

主要的SDK管理类，提供统一的广告管理接口。

**主要方法：**

- `initialize(appId:debug:completion:)` - 初始化SDK
- `isInitialized` - 是否已初始化
- `getVersion()` - 获取SDK版本
- `getAdsConfig()` - 获取广告配置

#### ADXiluBaseAd

广告基类，所有广告类型的父类。

**属性：**

- `adPosId: String` - 广告位ID
- `adSize: ADXiluAdSize` - 广告尺寸
- `delegate: ADXiluBaseAdDelegate?` - 代理
- `countdownDuration: TimeInterval` - 倒计时时长

**方法：**

- `loadAd()` - 加载广告
- `showAd(in:)` - 展示广告

#### ADXiluAdSize

广告尺寸类。

**属性：**

- `width: CGFloat` - 宽度
- `height: CGFloat` - 高度

**静态方法：**

- `screenWidth` - 屏幕宽度
- `screenSize` - 屏幕尺寸

#### ADXiluAdInfo

广告信息类。

**属性：**

- `adId: String` - 广告ID
- `platform: ADXiluAdPlatform` - 广告平台
- `isReady: Bool` - 是否准备就绪
- `rewardAmount: Int` - 奖励数量
- `rewardName: String` - 奖励名称
- `extraData: [String: Any]` - 额外数据

### 广告类型

#### ADXiluBannerAd

横幅广告类。

**属性：**

- `showCloseBtn: Bool` - 是否显示关闭按钮
- `containerView: UIView?` - 容器视图
- `autoRefreshInterval: Int` - 自动刷新间隔

#### ADXiluInterstitialAd

插屏广告类。

**初始化方法：**

- `init(adPosId:adSize:rootVC:)` - 初始化插屏广告

#### ADXiluRewardVodAd

激励视频广告类。

**属性：**

- `isMuted: Bool` - 是否静音
- `videoDelegate: ADXiluRewardVodAdDelegate?` - 视频代理

#### ADXiluSplashAd

开屏广告类。

**初始化方法：**

- `init(adPosId:style:adSize:)` - 初始化开屏广告

**属性：**

- `bottomView: UIView?` - 底部视图

#### ADXiluNativeAd

原生广告类。

**初始化方法：**

- `init(adPosId:adSize:count:)` - 初始化原生广告

**属性：**

- `nativeViewController: UIViewController?` - 原生视图控制器

### 代理协议

#### ADXiluBaseAdDelegate

广告事件代理协议。

**方法：**

- `xilu_AdDidReceive(_:adInfo:)` - 广告接收成功
- `xilu_AdDidReceiveMuti(_:adInfos:)` - 多个广告接收成功
- `xilu_AdDidExpose(_:adInfo:)` - 广告曝光
- `xilu_AdDidClick(_:adInfo:)` - 广告点击
- `xilu_AdDidClose(_:adInfo:)` - 广告关闭
- `xilu_AdDidSkip(_:adInfo:)` - 广告跳过
- `xilu_AdDidFail(_:error:)` - 广告加载失败
- `xilu_AdTick(_:remainingTime:)` - 倒计时回调

#### ADXiluRewardVodAdDelegate

激励视频广告专用代理协议。

**方法：**

- `xilu_AdVideoDidCache(_:adInfo:)` - 视频缓存完成
- `xilu_AdVideoDidComplete(_:adInfo:)` - 视频播放完成
- `xilu_AdVideoDidError(_:adInfo:error:)` - 视频播放错误
- `xilu_AdDidReward(_:adInfo:)` - 获得奖励

## 配置

### 初始化配置

```swift
// 初始化时设置调试模式
ADXiluSDKManager.shared.initialize(appId: "your_app_id", debug: true) { success, error in
    if success {
        print("SDK初始化成功")
    } else {
        print("SDK初始化失败: \(error ?? "")")
    }
}
```

### 广告位配置

SDK支持通过服务器配置广告位信息，包括：
- 广告位ID映射
- 平台优先级
- 广告尺寸配置
- 超时时间设置

## 示例项目

项目包含完整的示例应用，展示了各种广告类型的使用方法：

1. 克隆项目
2. 运行 `pod install`
3. 打开 `SwiftDemo.xcworkspace`
4. 运行示例应用

示例项目包含以下功能：
- 开屏广告演示
- 插屏广告演示
- 激励视频广告演示
- 原生广告演示
- Banner广告演示
- 完整的代理回调处理

## 架构设计

ADXiluSDK采用组件化架构设计：

```
ADXiluSDK/
├── Core/                    # 核心模块
│   ├── ADXiluSDKManager.swift     # 主管理类
│   ├── ADXiluBaseAd.swift  # 广告基类
│   ├── ADAdaptor.swift     # 适配器管理
│   └── ADNetworkTool.swift # 网络工具
├── Ads/                    # 广告模块
│   ├── ADXiluBannerAd.swift      # 横幅广告
│   ├── ADXiluInterstitialAd.swift # 插屏广告
│   ├── ADXiluRewardVodAd.swift   # 激励视频广告
│   ├── ADXiluSplashAd.swift      # 开屏广告
│   └── ADXiluNativeAd.swift     # 原生广告
├── BeiZi/                  # BeiZiSDK适配器
├── MSMob/                  # MSMobAdSDK适配器
├── Extensions/              # 扩展模块
└── Tool/                   # 工具模块
    ├── ADDeviceInfoTool.swift    # 设备信息工具
    └── XLSDKLogTool.swift        # 日志工具
```

## 许可证

MIT License

## 支持

如有问题或建议，请联系：

- 邮箱: support@xilu.com
- 文档: https://github.com/XiluSdk_ios_pod.git
- 问题反馈: https://github.com/xilu/ADXiluSDK-iOS/issues

## 更新日志

### v1.0.0 (2025-10-27)
- 初始版本发布
- 支持MSMobAdSDK和BeiZiSDK集成
- 提供完整的广告类型支持
- 支持Objective-C和Swift
- 最低支持iOS 12.2
- 包含完整的示例项目
