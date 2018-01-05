//
//  EH_GestureDragView.m
//  GestureUnClock
//
//  Created by Monster on 2018/1/3.
//  Copyright © 2018年 Monster. All rights reserved.
//

#import "EH_GestureDragView.h"
#import "EH_GestureCircleView.h"
#import "EH_CircleViewModel.h"

#define EH_CircleMargin            (30.0)           //圈之间的间隔
#define EH_RowCount                (3)              //排列多少行
#define EH_ColumnCount             (3)              //排列多少列

@interface EH_GestureDragView()
<CAAnimationDelegate>

@property (nonatomic, strong) NSMutableArray * rectArray;

@property (nonatomic, strong) NSMutableArray * circleViewArray;

@property (nonatomic, strong) UIPanGestureRecognizer * panGes;

@property (nonatomic, assign) BOOL isSecondSetting;

@property (nonatomic, assign) BOOL canDrag;

@property (nonatomic, strong) NSMutableArray * saveSelectedPointArray;

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) CGPoint currentPoint;

@property (nonatomic, strong) CAShapeLayer * lineLayer;

@end

@implementation EH_GestureDragView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rectArray = [[NSMutableArray alloc] init];
        self.circleViewArray = [[NSMutableArray alloc] init];
        self.saveSelectedPointArray = [[NSMutableArray alloc] init];
        self.isSecondSetting = NO;
        self.panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGes:)];
        [self addGestureRecognizer:self.panGes];
        [self layoutUI];
    }
    return self;
}

+ (CGFloat)getHeightOfDragView
{
    return SCREEN_WIDTH;
}

- (void)layoutUI
{
    self.lineLayer = [[CAShapeLayer alloc] init];
    self.lineLayer.frame = self.bounds;
    self.lineLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.lineLayer.lineWidth = 3;
    self.lineLayer.lineJoin = kCALineCapRound;
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.strokeColor = EH_NormalStateColor.CGColor;
    self.lineLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.lineLayer];
    [self updateUILayoutWithTypeWithFirst:YES];
}

- (void)updateUILayoutWithTypeWithFirst:(BOOL)first
{
    if (!first) {
        if (!self.modifyNum) {
            self.isSecondSetting = YES;
        }
        for (NSValue * value in self.saveSelectedPointArray) {
            [self changeCircleViewState:[value CGPointValue] state:Normal nextPoint:CGPointZero];
        }
        [self clearPath];
    }
    NSArray  * subArr = self.subviews;
    if(subArr){
        for (UIView * subView in subArr) {
            [subView removeFromSuperview];
        }
    }
    [self.rectArray removeAllObjects];
    [self.circleViewArray removeAllObjects];
    
    CGFloat  circleWidth = (SCREEN_WIDTH - (EH_ColumnCount + 1) * EH_CircleMargin) / (CGFloat)EH_ColumnCount;
    
    for (int i = 0; i < EH_RowCount; i ++) {
        for (int j = 0; j < EH_ColumnCount; j ++) {
            
            EH_GestureCircleView * circleView = [[EH_GestureCircleView alloc] initWithFrame:CGRectMake(EH_CircleMargin * (j + 1) + j * circleWidth, EH_CircleMargin * (i + 1) + i * circleWidth, circleWidth, circleWidth)];
            [self addSubview:circleView];
            [circleView setNormalState];
            circleView.layer.cornerRadius = circleWidth/2.0;
            circleView.layer.masksToBounds = YES;
            [self.circleViewArray addObject:circleView];
            EH_CircleViewModel * model = [[EH_CircleViewModel alloc] init];
            model.number = i * EH_RowCount + j + 1;
            model.circleRect = CGRectMake(EH_CircleMargin * (j + 1) + j * circleWidth, EH_CircleMargin * (i + 1) + i * circleWidth, circleWidth, circleWidth);
            [self.rectArray addObject:model];
            circleView.tag = model.number;
        }
    }
}

- (void)handlePanGes:(UIPanGestureRecognizer *)panGes
{
    switch (panGes.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self clearPath];
            self.startPoint = [panGes locationInView:panGes.view];
            CGPoint checkPoint = CGPointZero;
            checkPoint = [self checkConnectPoint:self.startPoint];
            if (checkPoint.x == 0 && checkPoint.y == 0) {
                self.canDrag = NO;
            }
            else
            {
                self.canDrag = YES;
                self.startPoint = checkPoint;
                [self.saveSelectedPointArray addObject:[NSValue valueWithCGPoint:checkPoint]];
                //需要将触碰的CircleView变化
                [self changeCircleViewState:self.startPoint state:Selected nextPoint:CGPointZero];
                [self drawDragPath];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (self.canDrag) {
                self.currentPoint = [panGes locationInView:panGes.view];
                CGPoint checkPoint = [self checkConnectPoint:self.currentPoint];
                if (checkPoint.x != 0 && checkPoint.y != 0) {
                    if (![self checkIsRepeatPath:checkPoint]) {
                        [self.saveSelectedPointArray addObject:[NSValue valueWithCGPoint:checkPoint]];
                        //需要将触碰的CircleView变化
                        [self changeCircleViewState:checkPoint state:Selected nextPoint:CGPointZero];
                    }
                    else
                    {
                        for (NSValue * value in self.saveSelectedPointArray) {
                            NSInteger index = [self.saveSelectedPointArray indexOfObject:value];
                            CGPoint nextPoint = CGPointZero;
                            if (index != self.saveSelectedPointArray.count - 1) {
                                nextPoint = [[self.saveSelectedPointArray objectAtIndex:index + 1] CGPointValue];
                                [self changeCircleViewState:[value CGPointValue] state:Disable nextPoint:nextPoint];
                            }
                            else
                            {
                                [self changeCircleViewState:[value CGPointValue] state:Selected nextPoint:CGPointZero];
                            }
                        }
                    }
                }
                [self drawDragPath];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            if (self.canDrag) {
                BOOL dragCorrect = YES;
                if (self.saveSelectedPointArray.count >= 4) {
                    self.currentPoint = [self.saveSelectedPointArray.lastObject CGPointValue];
                    [self drawDragPath];
                }
                else if (self.saveSelectedPointArray.count < 4)
                {
                    for (NSValue * value in self.saveSelectedPointArray) {
                        [self changeCircleViewState:[value CGPointValue] state:Normal nextPoint:CGPointZero];
                    }
                    [self clearPath];
                    self.canDrag = NO;
                    dragCorrect = NO;
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(gestureDragView:savePoint:finishSetting:dragCorrect:)]) {
                    BOOL ret = self.isSecondSetting;
                    if (self.modifyNum) {
                        ret = YES;
                    }
                    if (![self.delegate gestureDragView:self savePoint:[self getSavePointString] finishSetting:ret dragCorrect:dragCorrect]) {
                        //设置失败。第一次和第二次不一样，或者是修改密码和保存的不一样
                        [self setErrorPath];
                    }
                }
            }
            self.canDrag = NO;
        }
            break;
        default:
            break;
    }
}

- (void)clearPath
{
    [self.saveSelectedPointArray removeAllObjects];
    self.startPoint = CGPointZero;
    self.currentPoint = CGPointZero;
    [self drawDragPath];
}

//提供两个点，返回一个它们的中点
- (CGPoint)centerPointWithPointOne:(CGPoint)pointOne pointTwo:(CGPoint)pointTwo
{
    CGFloat x1 = fmax(pointOne.x, pointTwo.x);
    CGFloat x2 = fmin(pointOne.x, pointTwo.x);
    CGFloat y1 = fmax(pointOne.y, pointTwo.y);
    CGFloat y2 = fmin(pointOne.y, pointTwo.y);
    
    return CGPointMake((x1+x2)/2, (y1 + y2)/2);
}

- (void)drawDragPath
{
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    CGPathMoveToPoint(mutablePath, NULL, self.startPoint.x, self.startPoint.y);
    for (NSValue * value in self.saveSelectedPointArray) {
        CGPoint  point = [value CGPointValue];
        CGPathAddLineToPoint(mutablePath, NULL, point.x, point.y);
    }
    if (self.currentPoint.x != 0 && self.currentPoint.y != 0) {
        CGPathAddLineToPoint(mutablePath, NULL, self.currentPoint.x, self.currentPoint.y);
    }
    self.lineLayer.path = mutablePath;
    CGPathRelease(mutablePath);
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextAddRect(ctx, self.bounds);
//    // 遍历所有子控件
//    [self.subviews enumerateObjectsUsingBlock:^(EH_GestureCircleView *circle, NSUInteger idx, BOOL *stop) {
//
//        CGContextAddEllipseInRect(ctx, circle.frame); // 确定"剪裁"的形状
//    }];
//    //剪裁上下文
//    CGContextEOClip(ctx);
}

- (CGPoint)checkConnectPoint:(CGPoint)point
{
    CGPoint resultPoint = CGPointZero;
    for (EH_CircleViewModel * model in self.rectArray) {
        CGRect rect = model.circleRect;
        if (CGRectContainsPoint(rect, point)) {
            resultPoint = CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect)/2.0, CGRectGetMinY(rect) + CGRectGetHeight(rect)/2.0);
            break;
        }
    }
    return resultPoint;
}

- (BOOL)checkIsRepeatPath:(CGPoint)point
{
    BOOL result = NO;
    for (NSValue * value in self.saveSelectedPointArray) {
        CGPoint tempPoint = [value CGPointValue];
        if (point.x == tempPoint.x && point.y == tempPoint.y) {
            result = YES;
            break;
        }
    }
    return result;
}

- (void)changeCircleViewState:(CGPoint)point state:(CircleState)state nextPoint:(CGPoint)nextPoint
{
    for (EH_CircleViewModel * model in self.rectArray) {
        CGRect rect = model.circleRect;
        if (CGRectContainsPoint(rect, point)) {
            EH_GestureCircleView * view = [self viewWithTag:model.number];
            if (state == 0) {
                [view setNormalState];
            }
            else if (state == 1)
            {
                [view setSelectedState];
            }
            else if (state == 2)
            {
                CGFloat angle = atan2(nextPoint.y - point.y, nextPoint.x - point.x);
                view.angle = angle;
                [view setDisableState];
            }
            else if (state == 3)
            {
                [view setErrorState];
            }
            else
            {
                [view setNormalState];
            }
            break;
        }
    }
}

- (NSString *)getSavePointString
{
    NSString * string = @"";
    for (NSValue * value in self.saveSelectedPointArray) {
        for (EH_CircleViewModel * model in self.rectArray) {
            if (CGRectContainsPoint(model.circleRect, [value CGPointValue])) {
                if (string.length > 0) {
                    string = [NSString stringWithFormat:@"%@,%@",string,@(model.number).stringValue];
                }
                else
                {
                    string = [NSString stringWithFormat:@"%@",@(model.number).stringValue];
                }
                break;
            }
        }
    }
    return string;
}

- (void)setErrorPath
{
//    if (!self.isSecondSetting) {
//
//    }
    for (NSValue * value in self.saveSelectedPointArray) {
        [self changeCircleViewState:[value CGPointValue] state:Error nextPoint:CGPointZero];
    }
    self.lineLayer.strokeColor = EH_ErrorStateColor.CGColor;
    [self drawDragPath];
    CABasicAnimation  * ba = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    ba.delegate = self;
    ba.duration = 0.1;
    ba.fromValue = @(-10.0);
    ba.toValue = @(10.0);
    ba.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ba.repeatCount = 2.0;
    ba.autoreverses = YES;
    [self.lineLayer addAnimation:ba forKey:@"lineLayer"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self updateUILayoutWithTypeWithFirst:NO];
    self.lineLayer.strokeColor = EH_NormalStateColor.CGColor;
}

@end
