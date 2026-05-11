# SwParticles

Swift 2D particle system engine（灵感来自 [Proton](https://github.com/drawcall/Proton/)），支持发射器、行为、区域、对象池，以及基于 SwiftUI / Core Graphics 的渲染。

## 要求

- iOS 13.0+
- Swift 5.0+
- Xcode 14+（建议使用当前工具链）

## 安装

### CocoaPods

在 `Podfile` 中加入：

```ruby
pod 'SwParticles', '~> 0.1.0'
```

然后执行：

```bash
pod install
```

在代码中：

```swift
import SwParticles
```

### Swift Package Manager

在 Xcode：**File → Add Package Dependencies**，填入仓库地址：

`https://github.com/swiftuilab/SwParticles`

或在其它 SPM 工程的 `Package.swift` 中：

```swift
dependencies: [
    .package(url: "https://github.com/swiftuilab/SwParticles.git", from: "0.1.0")
]
```

## 发布 Pod（维护者）

1. 更新 `SwParticles.podspec` 与 `README` 中的版本号。
2. 打 tag 并与 `s.version` 一致，例如：`git tag 0.1.0 && git push origin 0.1.0`。
3. 注册 trunk（首次）：`pod trunk register <email> '<name>'`。
4. 推送：`pod trunk push SwParticles.podspec`。

本地校验：

```bash
pod lib lint SwParticles.podspec --allow-warnings
```

## 许可证

[MIT](LICENSE)
