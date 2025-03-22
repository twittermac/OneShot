platform :ios, '15.0'

target 'OneShot' do
  use_frameworks!

  # Agora SDK
  pod 'AgoraRtcKit'

  # Networking
  pod 'Alamofire'
  pod 'SwiftyJSON'

  # UI Components
  pod 'SnapKit'
  pod 'Kingfisher'

  # Analytics & Monitoring
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Performance'

  # Testing
  target 'OneShotTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end

  target 'OneShotUITests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end 