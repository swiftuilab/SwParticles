Pod::Spec.new do |s|
  s.name             = 'SwParticles'
  s.version          = '0.1.0'
  s.summary          = 'Swift 2D particle system engine with SwiftUI renderers'
  s.description      = <<-DESC
    SwParticles is a 2D particle engine for Swift, inspired by Proton.js. It includes
    emitters, behaviors, zones, pooling, and SwiftUI/CoreGraphics-based renderers for iOS.
                       DESC
  s.homepage         = 'https://github.com/swiftuilab/SwParticles'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'swiftuilab' => 'https://github.com/swiftuilab' }
  s.source           = { :git => 'https://github.com/swiftuilab/SwParticles.git', :tag => s.version.to_s }

  s.swift_versions   = ['5.0', '5.9']
  s.ios.deployment_target = '13.0'

  s.source_files = [
    'Behaviour/**/*.swift',
    'Core/**/*.swift',
    'Emitter/**/*.swift',
    'Events/**/*.swift',
    'Initialize/**/*.swift',
    'Math/**/*.swift',
    'Render/**/*.swift',
    'Utils/**/*.swift',
    'Zone/**/*.swift',
    'SwParticlesExports.swift'
  ]

  s.frameworks = 'Foundation', 'SwiftUI', 'CoreGraphics', 'UIKit'

  s.requires_arc = true
end
