//
//  EH_GestureCircleView.h
//  GestureUnClock
//
//  Created by Monster on 2018/1/3.
//  Copyright © 2018年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EH_SolidCircleRaduis                    (15.0)            //中心实心圆半径
#define EH_NormalStateColor    ([UIColor colorWithRed:42.0 / 255.0  green:155.0 / 255.0 blue:236.0 / 255.0 alpha:1.0])   //蓝色,正常
#define EH_ErrorStateColor     ([UIColor colorWithRed:244.0 / 255.0  green:51.0 / 255.0 blue:60.0 / 255.0 alpha:1.0])    //红色,错误

typedef NS_ENUM(NSUInteger, CircleState) {
    Normal = 0,
    Selected = 1,
    Disable = 2,
    Error = 3,
};

@interface EH_GestureCircleView : UIView

- (void)setNormalState;

- (void)setSelectedState;

- (void)setDisableState;

- (void)setErrorState;

@end
