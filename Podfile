platform :ios, '15'

target 'ValuCards' do
  use_frameworks!

  # Pods for ValuCards
  pod 'Alamofire'
  pod 'DGCharts'
  pod 'SDWebImage'
  pod 'GoogleSignIn'
  pod 'Firebase'
  pod 'FirebaseCore'
  pod 'FirebaseAuth'
  pod 'FirebasePerformance'

target :ValuCardsNewTests

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    installer_representation.aggregate_targets.each do |target|
      target.xcconfigs.each do |variant, xcconfig|
        xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
        IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
      end
    end
    installer_representation.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
          xcconfig_path = config.base_configuration_reference.real_path
          IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
        end
      end
    end
  end
end
end