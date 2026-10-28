platform :ios, '15.0'

source 'https://github.com/CocoaPods/Specs.git'

source 'https://bitbucket.org/crackle-tech/cricheroes.git'

source 'https://bitbucket.org/crackle-tech/cracklesdk_ios.git'

target 'tempApp_onlyCrackle' do
  use_frameworks!

  pod 'CricHeroesCrackleGoogleAdManagerAdapter'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |t|
    t.build_configurations.each do |c|
      c.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
