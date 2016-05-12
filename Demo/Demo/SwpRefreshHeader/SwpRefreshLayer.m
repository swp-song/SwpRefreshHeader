//
//  SwpRefreshLayer.m
//  swp_song
//
//  Created by swp_song on 16/5/12.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "SwpRefreshLayer.h"


static CGFloat  viewHeighte                      = 21;
static CGFloat  pointWidth                       = 10.0;


static BOOL     isAnimationing;
static NSString *kName                           = @"ScaleAnimationName";

// 默认 颜色
static NSInteger const kFirstPointColorHexValue  = 0xdc5753;
static NSInteger const kSecondPointColorHexValue = 0x354d59;
static NSInteger const kThirdPointColorHexValue  = 0x4db19e;
static NSInteger const kFourthPointColorHexValue = 0xeeb269;

// 默认 动画执行时间
static CGFloat   const kScaleTimeValue           = 0.35;

@interface SwpRefreshLayer()

// 颜色 属性 值
@property (nonatomic, assign) NSInteger firstPointColorHexValue;
@property (nonatomic, assign) NSInteger secondPointColorHexValue;
@property (nonatomic, assign) NSInteger thirdPointColorHexValue;
@property (nonatomic, assign) NSInteger fourthPointColorHexValue;

/** @brief  动画属性 (外部无需调用) */
@property (nonatomic, assign) CGFloat   animationScale;

@end

@implementation SwpRefreshLayer

@dynamic animationScale;
@dynamic firstPointColorHexValue;
@dynamic secondPointColorHexValue;
@dynamic thirdPointColorHexValue;
@dynamic fourthPointColorHexValue;


-(void)setFrame:(CGRect)frame {
    CGRect newFrame     = CGRectMake(0, 10, CGRectGetWidth(frame), 2 * viewHeighte);
    [super setFrame:newFrame];
    self.scaleTimeValue = kScaleTimeValue;
    [self setPointColorHexValue:kFirstPointColorHexValue secondPointColorHexValue:kSecondPointColorHexValue thirdPointColorHexValue:kThirdPointColorHexValue fourthPointColorHexValue:kFourthPointColorHexValue];
}
//#warning message == 这里有一处 BUG 仅仅给出了暂时解决方法没有探明 产生的原因
//为什么外部传入 0.875 时  会调用两次此函数，并且在第二次传入 0 ,但是验证得到第二次并不是外部调用的结果，但是 0.875 这个值是由外界决定的
//补充 bug 产生的原因已经明确了 是由于 -stopAnimation的反复调用引起的
- (void)setComplete:(CGFloat)complete {
    if (_complete != complete) {
        _complete = complete;
        [self setNeedsDisplay];
    }
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"animationScale"]) {
        return YES;
    }else {
        return [super needsDisplayForKey:key];
    }
}


/*!
 *  @author swp_song
 *
 *  @brief  beginAnimation  ( 开始动画 开始刷新时调用 )
 */
-(void)beginAnimation {
    isAnimationing = YES;
    [self addScaleSmallAnimation];
    CABasicAnimation *rotate   = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.fromValue           = @(0);
    rotate.toValue             = @(M_PI * 2);
    rotate.duration            = 4 * self.scaleTimeValue;
    rotate.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotate.repeatCount         = HUGE;//MAXFLOAT
    rotate.fillMode            = kCAFillModeForwards;
    rotate.removedOnCompletion = NO;
    [self addAnimation:rotate forKey:rotate.keyPath];
}
- (void)addScaleSmallAnimation {
    self.animationScale          = 0.6;
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"animationScale"];
    animation1.duration          = self.scaleTimeValue;
    animation1.fromValue         = @(1.0);
    animation1.toValue           = @(0.6);
    animation1.delegate          = self;
    [animation1 setValue:@"ScaleSamll" forKey:kName];
    [self addAnimation:animation1 forKey:@"animationScale"];
}

- (void)addScaleBigAnimation {
    self.animationScale          = 1.0;
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"animationScale"];
    animation1.duration          = self.scaleTimeValue;
    animation1.fromValue         = @(0.6);
    animation1.toValue           = @(1.0);
    animation1.delegate          = self;
    [animation1 setValue:@"ScaleBig" forKey:kName];
    [self addAnimation:animation1 forKey:@"animationScale"];
}

/*!
 *  @author swp_song
 *
 *  @brief  stopAnimation   ( 停止动画 刷新结束调用 )
 */
- (void)stopAnimation {
#if 1
    if (!isAnimationing) {
        return;
    }
#endif
    isAnimationing = NO;
    [self removeAllAnimations];
    self.complete = 0.0;
    [self setNeedsDisplay];
}


/*!
 *  @author swp_song
 *
 *  @brief  drawInContext:  ( 绘制 样式 )
 *
 *  @param ctx
 */
- (void)drawInContext:(CGContextRef)ctx {
    CGPoint center      = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGPoint firstPoint  = CGPointMake(center.x,center.y-viewHeighte+pointWidth/2);
    CGPoint secondPoint = CGPointMake(center.x-viewHeighte+pointWidth/2, center.y);
    CGPoint thirdPoint  = CGPointMake(center.x, center.y+viewHeighte-pointWidth/2);
    CGPoint fourthPoint = CGPointMake(center.x+viewHeighte-pointWidth/2, center.y);
    if (isAnimationing) {
        CGFloat scale            = [(SwpRefreshLayer *)self.presentationLayer animationScale];
        CGPoint ScaleFirstPoint  = currentProportionPoint(center, firstPoint, scale);
        CGPoint ScaleSecondPoint = currentProportionPoint(center, secondPoint, scale);
        CGPoint ScaleThiredPoint = currentProportionPoint(center, thirdPoint, scale);
        CGPoint ScaleFourthPoint = currentProportionPoint(center, fourthPoint, scale);
        
        drawPointAtRect(ScaleFirstPoint,ctx,  [self swpColorFromHex:self.firstPointColorHexValue  alpha:1].CGColor);
        drawPointAtRect(ScaleSecondPoint,ctx, [self swpColorFromHex:self.secondPointColorHexValue alpha:1].CGColor);
        drawPointAtRect(ScaleThiredPoint,ctx, [self swpColorFromHex:self.thirdPointColorHexValue  alpha:1].CGColor);
        drawPointAtRect(ScaleFourthPoint,ctx, [self swpColorFromHex:self.fourthPointColorHexValue alpha:1].CGColor);
    }else {
        //绘制第一个点
        CGFloat firstPA = MIN(1, MAX(0, self.complete/0.2));
        //  NSLog(@"%.2f _complete = %.2f",firstPA,self.complete);
        drawPointAtRect(firstPoint,ctx,[self swpColorFromHex:self.firstPointColorHexValue alpha:firstPA].CGColor);
        if (self.complete>0.225 && self.complete<0.375) {
            //这里要 绘制第一个线条
            if (self.complete<0.3) {
                CGFloat scale = (self.complete-0.225)/0.075;
                drawLineInContextFromStartPointAndEndPointWithScale(ctx, firstPoint, secondPoint, scale, [self swpColorFromHex:self.firstPointColorHexValue alpha:1]);
            }else {
                CGFloat scale = (0.375-self.complete)/0.075;
                drawLineInContextFromStartPointAndEndPointWithScale(ctx, secondPoint, firstPoint, scale, [self swpColorFromHex:self.firstPointColorHexValue alpha:1]);
            }
        }else if (self.complete >= 0.375 ) {
            //必定绘制第二个圆
            drawPointAtRect(secondPoint,ctx, [self swpColorFromHex:self.secondPointColorHexValue alpha:1].CGColor);
            if (self.complete > 0.425 && self.complete < 0.575) {
                //绘制第二条线条
                if (self.complete<0.5) {
                    CGFloat scale = (self.complete-0.425)/0.075;
                    drawLineInContextFromStartPointAndEndPointWithScale(ctx, secondPoint, thirdPoint, scale, [self swpColorFromHex:self.secondPointColorHexValue alpha:1]);
                }else {
                    CGFloat scale = (0.575-self.complete)/0.075;
                    drawLineInContextFromStartPointAndEndPointWithScale(ctx, thirdPoint, secondPoint, scale, [self swpColorFromHex:self.secondPointColorHexValue alpha:1]);
                }
            }else if (self.complete >= 0.575) {
                //必定绘制 第三个圆
                drawPointAtRect(thirdPoint,ctx, [self swpColorFromHex:self.thirdPointColorHexValue alpha:1].CGColor);
                if (self.complete > 0.625 && self.complete < 0.775) {
                    //绘制第三条线
                    if (self.complete<0.7) {
                        CGFloat scale = (self.complete-0.625)/0.075;
                        drawLineInContextFromStartPointAndEndPointWithScale(ctx, thirdPoint, fourthPoint, scale,[self swpColorFromHex:self.thirdPointColorHexValue alpha:1]);
                    }else {
                        CGFloat scale = (0.775-self.complete)/0.075;
                        drawLineInContextFromStartPointAndEndPointWithScale(ctx, fourthPoint, thirdPoint, scale, [self swpColorFromHex:self.thirdPointColorHexValue alpha:1]);
                    }
                }else if (self.complete >= 0.775) {
                    //必定绘制第四个圆
                    drawPointAtRect(fourthPoint,ctx, [self swpColorFromHex:self.fourthPointColorHexValue alpha:1].CGColor);
                    if (self.complete > 0.825 && self.complete < 0.975) {
                        //绘制第四条线
                        if (self.complete<0.9) {
                            CGFloat scale = (self.complete-0.825)/0.075;
                            drawLineInContextFromStartPointAndEndPointWithScale(ctx, fourthPoint, firstPoint, scale, [self swpColorFromHex:self.fourthPointColorHexValue alpha:1]);
                        }else {
                            CGFloat scale = (0.975-self.complete)/0.075;
                            drawLineInContextFromStartPointAndEndPointWithScale(ctx, firstPoint, fourthPoint, scale, [self swpColorFromHex:self.fourthPointColorHexValue alpha:1]);
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - Animation Delegart
/*!
 *  @author swp_song
 *
 *  @brief  animationDidStop:finished:  ( 动画 停止 调用方法 )
 *
 *  @param  anim
 *
 *  @param  flag
 */
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:kName] isEqualToString:@"ScaleSamll"]) {
        if (isAnimationing) {
            [self addScaleBigAnimation];
        }
    }else if ([[anim valueForKey:kName] isEqualToString:@"ScaleBig"]) {
        if (isAnimationing) {
            [self addScaleSmallAnimation];
        }
    }
}


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
- (void)setPointColorHexValue:(NSInteger)firstPointColorHexValue secondPointColorHexValue:(NSInteger)secondPointColorHexValue thirdPointColorHexValue:(NSInteger)thirdPointColorHexValue fourthPointColorHexValue:(NSInteger)fourthPointColorHexValue {
    self.firstPointColorHexValue  = firstPointColorHexValue;
    self.secondPointColorHexValue = secondPointColorHexValue;
    self.thirdPointColorHexValue  = thirdPointColorHexValue;
    self.fourthPointColorHexValue = fourthPointColorHexValue;
}

/*!
 *  @author swp_song
 *
 *  @brief  swpColorFromHex:alpha:
 *
 *  @param  hexValue
 *
 *  @param  alpha
 *
 *  @return UIColor
 */
- (UIColor *)swpColorFromHex:(NSInteger)hexValue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:alpha];
}

/*!
 *  @author swp_song
 *
 *  @brief  setScaleTimeValue:  ( 设置 动画 时间 )
 *
 *  @param  scaleTimeValue
 */
- (void)setScaleTimeValue:(CGFloat)scaleTimeValue {
    _scaleTimeValue = scaleTimeValue;
}



#pragma mark ==== 计算类的方法
void drawPointAtRect (CGPoint center,CGContextRef ctx, CGColorRef color) {
    CGContextSetFillColorWithColor(ctx, color);
    CGMutablePathRef Path = CGPathCreateMutable();
    CGPathMoveToPoint(Path, NULL, center.x, center.y);
    CGPathAddArc(Path, NULL, center.x, center.y, pointWidth/2, (float)(2.0*M_PI), 0.0, TRUE);
    CGPathCloseSubpath(Path);
    CGContextAddPath(ctx, Path);
    CGContextFillPath(ctx);
    CGPathRelease(Path);
}

CGPoint currentProportionPoint(CGPoint starPoint, CGPoint endPoint, CGFloat scale) {
    CGFloat lengthOfX = endPoint.x - starPoint.x;
    CGFloat pointX    = starPoint.x + lengthOfX * scale;
    CGFloat lengthOfY = endPoint.y - starPoint.y;
    CGFloat pointY    = starPoint.y + lengthOfY * scale;
    return CGPointMake(pointX, pointY);
}

void drawLineInContextFromStartPointAndEndPointWithScale (CGContextRef ctx, CGPoint starPoint, CGPoint endPoint, CGFloat scale, UIColor *storkeColor) {
    CGContextSetStrokeColorWithColor(ctx, storkeColor.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, starPoint.x, starPoint.y);
    CGPoint currentPoint  = currentProportionPoint(starPoint, endPoint, scale);
    CGPathAddLineToPoint(path, NULL, currentPoint.x, currentPoint.y);
    CGPathCloseSubpath(path);
    CGContextAddPath(ctx, path);
    CGContextSetLineWidth(ctx, pointWidth);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextStrokePath(ctx);
    CGPathRelease(path);
}



@end
