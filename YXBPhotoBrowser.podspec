
Pod::Spec.new do |s|
  s.name             = 'YXBPhotoBrowser'
  s.version          = '0.0.3'
  s.summary          = 'A simple photobrowser.'
  s.description      = <<-DESC 
  仿微信大图浏览，参考了很多HZPhotoBrowser的实现，但是更易于使用。
					   DESC
  s.homepage         = 'https://github.com/bing900717/YXBPhotoBrowser'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yaoxb' => '1375216660@qq.com' }
  s.source           = { :git => 'https://github.com/bing900717/YXBPhotoBrowser.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'YXBPhotoBrowser/**/*.{h,m}'  
  s.dependency 'YYKit', '~> 1.0.9'
  s.requires_arc = true
  
end
