//
//  EH_GestureDragView.h
//  GestureUnClock
//
//  Created by Monster on 2018/1/3.
//  Copyright © 2018年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT       ([UIScreen mainScreen].bounds.size.height)

@class EH_GestureDragView;
@protocol EH_GestureDragViewDelegate <NSObject>

- (BOOL)gestureDragView:(EH_GestureDragView *)dragView savePoint:(NSString *)savePointString finishSetting:(BOOL)finish dragCorrect:(BOOL)dragCorrect;

@end

@interface EH_GestureDragView : UIView

@property (nonatomic,weak) id<EH_GestureDragViewDelegate>delegate;

@property (nonatomic, assign) BOOL modifyNum;

- (void)updateUILayoutWithTypeWithFirst:(BOOL)first;

@end
