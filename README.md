# SwpRefreshHeader


___模仿Boos职聘下拉刷新 < 搬运，基于 MJRefresh 框架>___

首先感谢提供代码的童鞋 

___简书坤___
< 简书-ID > :	
<http://www.jianshu.com/p/87229a563d38>

___kun___
< Git-ID > :
<https://github.com/gitKun/-Boss->

MJRefresh : 
<https://github.com/CoderMJLee/MJRefresh>

__依赖库 MJRefresh__

简单的封装了下, 先看效果:
***
![(图片轮播效果)](https://raw.githubusercontent.com/swp-song/SwpRefreshHeader/master/Screenshot/SwpRefreshHeader.gif)
***


##### 导入：

```ruby
头文件:

SwpHeaderRefresh.h	是已经写好一个头文件 可以直接拿来使用

SwpRefreshLayer.h	核心动画, 可以导入, 重写刷新头文件


手动导入：
SwpRefreshHeader 文件夹 导入 项目 中, 依赖 MJRefresh

#import "SwpHeaderRefresh.h"
#import "SwpRefreshLayer.h"

CocoaPods 导入:

使用  CocoaPods 会自动 pod MJRefresh

pod searchSwpHeaderRefresh

pod 'SwpHeaderRefresh'

#import <SwpRefreshHeader/SwpHeaderRefresh.h>
#import <SwpRefreshHeader/SwpRefreshLayer.h>
```
---

##### 使用：
```Objective-C


#import "SwpHeaderRefresh.h" | #import <SwpRefreshHeader/SwpHeaderRefresh.h>

// 1. 直接 设置 SwpHeaderRefresh.h 头文件
self.demoTableView.mj_header = [SwpHeaderRefresh headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshingData)];

#import "SwpRefreshLayer.h" | #import <SwpRefreshHeader/SwpRefreshLayer.h>
// 2. 重写 刷新头文件 集成 MJRefreshGifHeader 或 MJRefreshHeader 具体设置 请看Demo SwpHeaderRefresh.h 文件

// 设置 刷新 四个 点 && 线的颜色
[_swpRefreshLayer setPointColorHexValue:0xffb8e7 secondPointColorHexValue:0xffecb9 thirdPointColorHexValue:0xc4a3f7 fourthPointColorHexValue:0x98d8ff];

// 设置 刷新 动画时间
_scaleTimeValue.scaleTimeValue = 1.0;
[_swpRefreshLayer setScaleTimeValue:1.0];
```
---

##### 备注:
```
交流 群号 : 85400118
```







	





