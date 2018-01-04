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

@property (nonatomic, assign) BOOL rotate;

@end

@implementation EH_GestureCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rotate = NO;
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI
{
    self.backgroundColor = [UIColor whiteColor];
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
    [self getTrianglePath];
    self.triangleLayer.hidden = YES;
    [self.layer addSublayer:self.triangleLayer];
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
    CGFloat width = CGRectGetWidth(self.frame);
    CGPoint point = CGPointMake(width/2.0, width/6.0);
    CGFloat length = width/6.0;
    CGPathMoveToPoint(trianglePathM, NULL, point.x, point.y);
    CGPathAddLineToPoint(trianglePathM, NULL, point.x - length/2, point.y + length/2);
    CGPathAddLineToPoint(trianglePathM, NULL, point.x + length/2, point.y + length/2);
    self.triangleLayer.path = trianglePathM;
    CGPathRelease(trianglePathM);
}

- (void)setAngle:(CGFloat)angle
{
    _angle = angle;
//    if (!self.rotate) {
        //整体旋转
        self.transform = CGAffineTransformMakeRotation (angle + M_PI_2);
//    }
}

- (void)setNormalState
{
    self.subLayer.strokeColor = EH_NormalStateColor.CGColor;
    self.solidCircle.hidden = YES;
    self.triangleLayer.hidden = YES;
    self.triangleLayer.fillColor = EH_NormalStateColor.CGColor;
    self.triangleLayer.strokeColor = EH_NormalStateColor.CGColor;
}

- (void)setSelectedState
{
    self.subLayer.strokeColor = EH_NormalStateColor.CGColor;
    self.solidCircle.hidden = NO;
    self.solidCircle.backgroundColor = EH_NormalStateColor;
    self.triangleLayer.hidden = YES;
    self.triangleLayer.fillColor = EH_NormalStateColor.CGColor;
    self.triangleLayer.strokeColor = EH_NormalStateColor.CGColor;
}

- (void)setDisableState
{//带个小三角
    self.subLayer.strokeColor = EH_NormalStateColor.CGColor;
    self.solidCircle.hidden = NO;
    self.solidCircle.backgroundColor = EH_NormalStateColor;
    self.triangleLayer.hidden = NO;
    self.triangleLayer.fillColor = EH_NormalStateColor.CGColor;
    self.triangleLayer.strokeColor = EH_NormalStateColor.CGColor;
}

- (void)setErrorState
{
    self.subLayer.strokeColor = EH_ErrorStateColor.CGColor;
    self.solidCircle.hidden = NO;
    self.solidCircle.backgroundColor = EH_ErrorStateColor;
    self.triangleLayer.fillColor = EH_ErrorStateColor.CGColor;
    self.triangleLayer.strokeColor = EH_ErrorStateColor.CGColor;
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
