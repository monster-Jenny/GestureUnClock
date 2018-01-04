//
//  EH_CircleViewModel.m
//  GestureUnClock
//
//  Created by Monster on 2018/1/4.
//  Copyright © 2018年 Monster. All rights reserved.
//

#import "EH_CircleViewModel.h"

@implementation EH_CircleViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.number = 0;
        self.circleRect = CGRectZero;
    }
    return self;
}
@end
