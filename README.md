# SwParticles

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS%2013%2B-lightgrey.svg)](SwParticles.podspec)
[![Swift](https://img.shields.io/badge/Swift-5.0%2B-orange.svg)](https://swift.org)

SwParticles is a **2D particle system engine** for Swift. It is inspired by the architecture of [Proton](https://github.com/drawcall/Proton/) (JavaScript) and targets **iOS** applications that use **SwiftUI** for rendering.

The library separates simulation (particles, emitters, behaviours, zones) from drawing (`BaseRenderer`, `CanvasRenderer`, `CoreGraphicsRenderer`), so you can drive visuals from `Canvas` or custom pipelines.

## Features

- **Core simulation**: central engine (`SwParticles`), particles, pooling (`Pool`), and typed particle data (`Data`, `PBody`).
- **Emitters**: spawn configuration via `Emitter` and initializer modules (life, velocity, position, rate, mass, and more under `Initialize/`).
- **Behaviours**: composable forces and effects—gravity, attraction, collision, colour tweaks, alpha, rotation, scaling, zone crossing, etc. (`Behaviour/`).
- **Zones**: geometric regions for emission and boundary logic (`Zone/`, `CircleZone`, `RectZone`, `LineZone`, `PointZone`, …).
- **Rendering**: SwiftUI-oriented renderers using `GraphicsContext`; optional Core Graphics / UIKit helpers where needed (`Render/`).
- **Math utilities**: vectors, spans, easing, integration helpers (`Math/`).

## Requirements

| Item        | Version |
|------------|---------|
| iOS        | 13.0+   |
| Swift      | 5.0+    |
| Xcode      | 14+ recommended |

UIKit and SwiftUI are used by parts of the public API (for example colour and image-backed particles). The package is **iOS-only** as declared in the podspec and Swift package manifest.

## Installation

### CocoaPods

Add SwParticles to your `Podfile`:

```ruby
platform :ios, '13.0'

target 'YourApp' do
  use_frameworks!
  pod 'SwParticles', '~> 0.1.0'
end
```

Then install dependencies:

```bash
pod install
```

Import in Swift:

```swift
import SwParticles
```

### Swift Package Manager

In Xcode: **File → Add Package Dependencies…** and enter:

`https://github.com/swiftuilab/SwParticles`

Or add the dependency to your own `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swiftuilab/SwParticles.git", from: "0.1.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [.product(name: "SwParticles", package: "SwParticles")]
    )
]
```

Because the library imports **UIKit**, resolve and build it inside an **iOS application or framework target** in Xcode. Running `swift build` from the command line on macOS targets the host SDK and will not succeed for this package.

## Repository layout

This repository follows a common layout that works with **both CocoaPods and SPM**:

```text
SwParticles/
├── LICENSE
├── Package.swift                 # Swift Package Manager manifest
├── README.md
├── SwParticles.podspec           # CocoaPods specification
└── Sources/
    └── SwParticles/              # Library source (single module)
        ├── Behaviour/
        ├── Core/
        ├── Emitter/
        ├── Events/
        ├── Initialize/
        ├── Math/
        ├── Render/
        ├── Utils/
        ├── Zone/
        └── SwParticlesExports.swift
```

Optional additions you may maintain separately (not required by the tools above):

- `Example/` — demo app consuming the pod or SPM product.
- `Tests/` — unit tests (add a test target in `Package.swift` when you introduce tests).

## Usage overview

1. Create a `SwParticles` instance (optionally with a custom `Pool`).
2. Configure one or more `Emitter` objects with initializers (`Life`, `Velocity`, `Position`, …).
3. Attach `Behaviour` subclasses to emitters or particles as needed.
4. Assign a renderer conforming to your drawing strategy (`CanvasRenderer` / `CoreGraphicsRenderer` subclasses of `BaseRenderer`).
5. Step the system each frame (`update` APIs on the engine—see `SwParticles` and emitters in source).

Refer to types listed in `Sources/SwParticles/SwParticlesExports.swift` for a module-level API checklist.

## Contributing

Issues and pull requests are welcome. Please keep changes focused, match existing Swift style in the tree, and update the podspec version together with git tags when releasing.

## Releasing (maintainers)

1. Bump `s.version` in `SwParticles.podspec` and document changes if you keep a changelog.
2. Tag the release: `git tag 0.1.0 && git push origin 0.1.0` (tag must match the podspec version).
3. Publish to CocoaPods trunk: `pod trunk push SwParticles.podspec` (after [registering](https://guides.cocoapods.org/making/getting-setup-with-trunk.html) if needed).

Validate locally before pushing:

```bash
pod lib lint SwParticles.podspec --allow-warnings
```

## License

SwParticles is released under the [MIT License](LICENSE).

## Acknowledgements

Design inspiration from [Proton](https://github.com/drawcall/Proton/) by @drawcall.
