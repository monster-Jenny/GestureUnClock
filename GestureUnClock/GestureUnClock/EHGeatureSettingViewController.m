//
//  EHGeatureSettingViewController.m
//  GestureUnClock
//
//  Created by Monster on 2018/1/3.
//  Copyright © 2018年 Monster. All rights reserved.
//

#import "EHGeatureSettingViewController.h"
#import "EH_GestureDragView.h"

NSString *const FirstSetting = @"绘制解锁图案";
NSString *const SecondSetting = @"再次绘制解锁图案";
NSString *const SelectedCircleCountLessThanFour = @"至少连接4个点,请重新输入";
NSString *const IsDifferentFromTheFirst = @"与上一次绘制不一致，请重新绘制";
NSString *const IsModifyNum = @"请输入原手势密码";
NSString *const ErrorGestureNumber = @"密码错误，还可以输入3次";



@interface EHGeatureSettingViewController ()<EH_GestureDragViewDelegate>

@property (nonatomic, strong) UILabel * label;

@end

@implementation EHGeatureSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
}

- (void)layoutUI
{
    [self.view addSubview:self.label];
    if (self.isModifyNum) {
        self.label.text = IsModifyNum;
    }
    else
    {
        self.label.text = FirstSetting;
    }
    EH_GestureDragView * dragView = [[EH_GestureDragView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH)];
    dragView.delegate = self;
    dragView.modifyNum = self.isModifyNum;
    [self.view addSubview:dragView];
}

#pragma mark - <EH_GestureDragViewDelegate>
- (BOOL)gestureDragView:(EH_GestureDragView *)dragView savePoint:(NSString *)savePointString finishSetting:(BOOL)finish dragCorrect:(BOOL)dragCorrect
{
    BOOL success = YES;
    if (finish) {
        //第二次绘制或者是输入密码
        NSString * saveStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"gestureNumber"];
        if ([saveStr isEqualToString:savePointString]) {
            if (self.isModifyNum) {
                EHGeatureSettingViewController * ctl = [[EHGeatureSettingViewController alloc] init];
                ctl.isModifyNum = NO;
                [self.navigationController pushViewController:ctl animated:YES];
            }
            else
            {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"设置成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                [alertView addAction:okAction];
                [self presentViewController:alertView animated:YES completion:nil];
            }
        }
        else
        {
            if (self.isModifyNum) {
                //密码输入错误，请重新输入
                [dragView updateUILayoutWithTypeWithFirst:NO];
                self.label.text = ErrorGestureNumber;
            }
            else
            {
                //绘制和第一次不一样，请重新绘制
                [dragView updateUILayoutWithTypeWithFirst:NO];
                self.label.text = IsDifferentFromTheFirst;
            }
        }
    }
    else
    {
        if (dragCorrect) {
            [[NSUserDefaults standardUserDefaults] setObject:savePointString forKey:@"gestureNumber"];
            [dragView updateUILayoutWithTypeWithFirst:NO];
            self.label.text = SecondSetting;
        }
        else
        {
            [dragView updateUILayoutWithTypeWithFirst:YES];
            self.label.text = SelectedCircleCountLessThanFour;
        }
    }
    return success;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60 , SCREEN_WIDTH, 40)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:20.0];
    }
    return _label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
