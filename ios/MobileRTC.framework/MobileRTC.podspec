Pod::Spec.new do |spec|
  spec.name         = "MobileRTC"
  spec.version      = "1.0.0"
  spec.summary      = "Zoom MobileRTC SDK"
  spec.description  = "The Zoom MobileRTC SDK allows integration of Zoom video conferencing features."
  spec.homepage     = "https://marketplace.zoom.us/docs/sdk/native-sdks/introduction"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Zoom" => "developer@zoom.us" }
  spec.platform     = :ios, "11.0"

  # Specify the framework
  spec.vendored_frameworks = "MobileRTC.framework"
  spec.frameworks = "AVFoundation", "CoreMedia", "VideoToolbox", "ReplayKit"
  spec.libraries = "c++", "z"

  # Dependencies
  spec.dependency "Flutter"
end
