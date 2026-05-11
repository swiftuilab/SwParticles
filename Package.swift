// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SwParticles",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "SwParticles", targets: ["SwParticles"])
    ],
    targets: [
        .target(
            name: "SwParticles",
            path: "Sources/SwParticles"
        )
    ]
)
