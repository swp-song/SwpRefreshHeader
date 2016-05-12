//
//  SwpRefreshLayer.h
//  swp_song
//
//  Created by swp_song on 16/5/12.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface SwpRefreshLayer : CALayer


@property (nonatomic, assign) CGFloat complete;

/*! 刷新动画时间 !*/
@property (nonatomic, assign) CGFloat scaleTimeValue;

/*!
 *  @author swp_song
 *
 *  @brief  setScaleTimeValue:  ( 设置 动画 时间 )
 *
 *  @param  scaleTimeValue
 */
- (void)setScaleTimeValue:(CGFloat)scaleTimeValue;

/*!
 *  @author swp_song
 *
 *  @brief  beginAnimation  ( 开始动画 开始刷新时调用 )
 */
-(void)beginAnimation;

/*!
 *  @author swp_song
 *
 *  @brief  stopAnimation   ( 停止动画 刷新结束调用 )
 */
- (void)stopAnimation;

/*!
 *  @author swp_song
 *
 *  @brief  setPointColorHexValue:firstPointColorHexValue:secondPointColorHexValue:thirdPointColorHexValue:fourthPointColorHexValue ( 这是 刷新 四个点的颜色 十六进制 色值 )
 *
 *  @param  firstPointColorHexValue
 *
 *  @param  secondPointColorHexValue
 *
 *  @param  thirdPointColorHexValue
 *
 *  @param  fourthPointColorHexValue
 */
- (void)setPointColorHexValue:(NSInteger)firstPointColorHexValue secondPointColorHexValue:(NSInteger)secondPointColorHexValue thirdPointColorHexValue:(NSInteger)thirdPointColorHexValue fourthPointColorHexValue:(NSInteger)fourthPointColorHexValue;

@end
NS_ASSUME_NONNULL_END
