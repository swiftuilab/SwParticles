Pod::Spec.new do |s|
  s.name             = 'SwParticles'
  s.version          = '0.1.0'
  s.summary          = 'A 2D particle system for Swift and SwiftUI on iOS'
  s.description      = <<-DESC
    SwParticles is a high-level 2D particle engine for Swift, conceptually inspired by
    the JavaScript Proton library. It provides emitters, modular behaviours, spatial
    zones, object pooling, and renderers built on SwiftUI and Core Graphics.
                       DESC
  s.homepage         = 'https://github.com/swiftuilab/SwParticles'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'swiftuilab' => 'https://github.com/swiftuilab' }
  s.source           = { :git => 'https://github.com/swiftuilab/SwParticles.git', :tag => s.version.to_s }

  s.swift_versions   = ['5.0', '5.9']
  s.ios.deployment_target = '15.0'

  s.source_files = 'Sources/SwParticles/**/*.swift'

  s.frameworks = 'Foundation', 'SwiftUI', 'CoreGraphics', 'UIKit'

  s.requires_arc = true
end
