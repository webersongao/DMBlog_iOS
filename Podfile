# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

target 'DMBlog' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DMBlog

    pod "WordPressKit"
    pod 'MMDrawerController'
    pod 'LookinServer', :configurations => ['Debug']

  target 'DMBlogTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DMBlogUITests' do
    # Pods for testing
  end

end


# 👇 添加这个 block
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
