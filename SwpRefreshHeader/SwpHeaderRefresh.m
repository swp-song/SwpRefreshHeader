//
//  SwpHeaderRefresh.m
//  Demo
//
//  Created by swp_song on 16/5/12.
//  Copyright © 2016年 swp_song. All rights reserved.
//

#import "SwpHeaderRefresh.h"

#import "SwpRefreshLayer.h"

@interface SwpHeaderRefresh ()

/*! SwpRefreshLayer  !*/
@property (nonatomic, strong) SwpRefreshLayer *swpRefreshLayer;

@end

@implementation SwpHeaderRefresh

/*!
 *  @author swp_song
 *
 *  @brief  prepare ( 重写 父类 方法 )
 */
- (void)prepare {
    [super prepare];
    
    // 隐藏 刷新 时间, 刷新状态
    self.stateLabel.hidden           = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    // 设置控件的高度
    self.mj_h                        = 80;
}

- (void)dealloc {
    [self.swpRefreshLayer stopAnimation];
}


/*!
 *  @author swp_song
 *
 *  @brief  placeSubviews   ( 置子控件的位置和尺寸 )
 */
- (void)placeSubviews {
    [super placeSubviews];
    if (!self.swpRefreshLayer) {
        _swpRefreshLayer               = [SwpRefreshLayer layer];
        _swpRefreshLayer.frame         = self.bounds;
        _swpRefreshLayer.contentsScale = [UIScreen mainScreen].scale;
        // 设置 4 个点的颜色
        [_swpRefreshLayer setPointColorHexValue:0xffb8e7 secondPointColorHexValue:0xffecb9 thirdPointColorHexValue:0xc4a3f7 fourthPointColorHexValue:0x98d8ff];
        // 设置 动画 快慢 转动速度
        // [_swpRefreshLayer setScaleTimeValue:0.35];
        [self.layer addSublayer:_swpRefreshLayer];
        
    }
}

/*!
 *  @author swp_song
 *
 *  @brief  setState:   ( 设置 刷新 状态 )
 *
 *  @param  state
 */
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle: {
            [self.swpRefreshLayer stopAnimation];
        }
            break;
        case MJRefreshStatePulling: {
        }
            break;
        case MJRefreshStateRefreshing: {
            [self.swpRefreshLayer beginAnimation];
        }
            break;
        default:
            break;
    }
}

/*!
 *  @author swp_song
 *
 *  @brief  setPullingPercent:  ( 设置 控件被拖出来的比例 )
 *
 *  @param  pullingPercent
 */
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    self.mj_y = -self.mj_h * MIN(1.0, MAX(0.0, pullingPercent));
    CGFloat complete = MIN(1.0, MAX(0.0, pullingPercent-0.125));
    self.swpRefreshLayer.complete = complete;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
