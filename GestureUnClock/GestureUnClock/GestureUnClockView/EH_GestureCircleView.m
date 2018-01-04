//
//  EH_GestureCircleView.m
//  GestureUnClock
//
//  Created by Monster on 2018/1/3.
//  Copyright © 2018年 Monster. All rights reserved.
//

#import "EH_GestureCircleView.h"

@interface EH_GestureCircleView ()

@property (nonatomic, strong) CAShapeLayer * subLayer;

@property (nonatomic, strong) UIView * solidCircle;

@property (nonatomic, strong) CAShapeLayer * triangleLayer;

@end

@implementation EH_GestureCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI
{
    self.subLayer = [CAShapeLayer layer];
    self.subLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.subLayer.frame = self.bounds;
    self.subLayer.path = [self getPath];
    [self.layer addSublayer:self.subLayer];
    
    [self addSubview:self.solidCircle];
    
    self.triangleLayer = [CAShapeLayer layer];
    self.triangleLayer.frame = self.bounds;
    self.triangleLayer.fillColor = EH_NormalStateColor.CGColor;
    self.triangleLayer.strokeColor = EH_NormalStateColor.CGColor;
    self.triangleLayer.lineWidth = 2.0;
    [self getTrianglePath];
    self.triangleLayer.hidden = YES;
}

- (CGPathRef)getPath{
    CGMutablePathRef  path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, self.subLayer.frame.size.width / 2.0, self.subLayer.frame.size.height / 2.0, CGRectGetWidth(self.frame)/ 2.0 - 1.0, 0.0, M_PI * 2.0, NO);
    self.subLayer.lineWidth = 2.0;
    self.subLayer.fillColor = [UIColor clearColor].CGColor;
    return path;
}

- (void)getTrianglePath
{
    //新建路径：三角形
    CGMutablePathRef trianglePathM = CGPathCreateMutable();
    CGRect rect = self.frame;
    CGFloat marginSelectedCirclev = 4.0f;
    CGFloat w =8.0f;
    CGFloat h =5.0f;
    CGFloat topX = rect.origin.x + rect.size.width * .5f;
//    CGFloat topY = rect.origin.y +(rect.size.width *.5f - h - marginSelectedCirclev - self.selectedRect.size.height *.5f);
    CGFloat topY = rect.origin.y +(rect.size.width *.5f - h - marginSelectedCirclev - rect.size.height *.5f);
    
    CGPathMoveToPoint(trianglePathM, NULL, topX, topY);
    
    //添加左边点
    CGFloat leftPointX = topX - w *.5f;
    CGFloat leftPointY =topY + h;
    CGPathAddLineToPoint(trianglePathM, NULL, leftPointX, leftPointY);
    
    //右边的点
    CGFloat rightPointX = topX + w *.5f;
    CGPathAddLineToPoint(trianglePathM, NULL, rightPointX, leftPointY);
    self.triangleLayer.path = trianglePathM;
    CGPathRelease(trianglePathM);
}

- (void)setNormalState
{
    self.subLayer.strokeColor = EH_NormalStateColor.CGColor;
    self.solidCircle.hidden = YES;
    self.triangleLayer.hidden = YES;
}

- (void)setSelectedState
{
    self.subLayer.strokeColor = EH_NormalStateColor.CGColor;
    self.solidCircle.hidden = NO;
    self.solidCircle.backgroundColor = EH_NormalStateColor;
    self.triangleLayer.hidden = YES;
}

- (void)setDisableState
{//带个小三角
    self.subLayer.strokeColor = EH_NormalStateColor.CGColor;
    self.solidCircle.hidden = NO;
    self.solidCircle.backgroundColor = EH_ErrorStateColor;
    self.triangleLayer.hidden = NO;
}

- (void)setErrorState
{
    self.subLayer.strokeColor = EH_ErrorStateColor.CGColor;
    self.solidCircle.hidden = NO;
    self.solidCircle.backgroundColor = EH_ErrorStateColor;
    self.triangleLayer.hidden = YES;
}

#pragma mark - getter
- (UIView *)solidCircle
{
    if (!_solidCircle) {
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat circleWidth = width / 7.0;
        _solidCircle = [[UIView alloc] initWithFrame:CGRectMake((width - circleWidth * 2)/2.0 , (width - circleWidth * 2)/2.0, circleWidth * 2, circleWidth * 2)];
        _solidCircle.layer.cornerRadius = circleWidth;
        _solidCircle.layer.masksToBounds = YES;
    }
    return _solidCircle;
}

@end
