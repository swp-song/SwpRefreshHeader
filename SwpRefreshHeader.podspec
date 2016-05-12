Pod::Spec.new do |s|
  s.name                  = "SwpRefreshHeader"
  s.version               = "1.0.0"
  s.ios.deployment_target = '7.0'
  s.summary               = " 封装下拉刷新的动画效果 类似于 Boos直聘 "
  s.homepage              = "https://github.com/swp-song/SwpRefreshHeader"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "swp-song" => "396587868@qq.com" }
  s.source                = { :git => "https://github.com/swp-song/SwpRefreshHeader.git", :tag => s.version }
  s.source_files          = "SwpRefreshHeader"
  s.requires_arc          = true
  s.dependency "MJRefresh"
end