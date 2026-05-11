# Contributing to SwParticles

Thank you for your interest in contributing. This document describes how we handle issues, pull requests, and releases for this library.

## Reporting issues

- Use [GitHub Issues](https://github.com/swiftuilab/SwParticles/issues).
- Search existing issues before opening a new one.
- Include: iOS version, Xcode version, integration method (CocoaPods or SPM), and a minimal description or code sample when reporting bugs.

## Pull requests

1. Fork the repository and create a branch from `main`.
2. Keep changes focused on a single topic (feature, fix, or docs).
3. Match existing Swift style in `Sources/SwParticles/` (naming, spacing, access control).
4. Update `CHANGELOG.md` under **Unreleased** (or the upcoming version section) when your change is user-visible.
5. If you change the public API or installation steps, update `README.md` as needed.
6. Version bumps and CocoaPods releases are usually done by maintainers; do not change `SwParticles.podspec` version in drive-by PRs unless asked.

## Development notes

- The library targets **iOS** and uses **UIKit** / **SwiftUI**; build and test inside an iOS project or simulator in Xcode rather than relying on `swift build` on macOS alone.
- Validate the podspec locally when you touch packaging:

  ```bash
  pod lib lint SwParticles.podspec --allow-warnings
  ```

## Code of conduct

Participants are expected to follow our [Code of Conduct](CODE_OF_CONDUCT.md).
