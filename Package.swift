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
            path: ".",
            exclude: [
                "LICENSE",
                "README.md",
                "SwParticles.podspec",
                ".gitignore"
            ],
            sources: [
                "Behaviour",
                "Core",
                "Emitter",
                "Events",
                "Initialize",
                "Math",
                "Render",
                "Utils",
                "Zone",
                "SwParticlesExports.swift"
            ]
        )
    ]
)
