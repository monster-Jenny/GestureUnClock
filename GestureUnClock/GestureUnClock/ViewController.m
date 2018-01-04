//
//  ViewController.m
//  GestureUnClock
//
//  Created by Monster on 2018/1/3.
//  Copyright © 2018年 Monster. All rights reserved.
//

#import "ViewController.h"
#import "EH_GestureDragView.h"
#import "EHGeatureSettingViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
}

- (void)layoutUI
{
    UIButton * setBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 80, SCREEN_WIDTH - 40, 50)];
    [setBtn setBackgroundColor:[UIColor redColor]];
    [setBtn setTitle:@"设置手势密码" forState:UIControlStateNormal];
    setBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [setBtn addTarget:self action:@selector(setNewGesture:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:setBtn];
    
    UIButton * reSetBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 180, SCREEN_WIDTH - 40, 50)];
    [reSetBtn setBackgroundColor:[UIColor redColor]];
    [reSetBtn setTitle:@"重新设置手势密码" forState:UIControlStateNormal];
    reSetBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [reSetBtn addTarget:self action:@selector(modifyGesture:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:reSetBtn];
}

- (void)setNewGesture:(UIButton *)sender
{
    EHGeatureSettingViewController * Ctl = [[EHGeatureSettingViewController alloc] init];
    Ctl.isModifyNum = NO;
    [self.navigationController pushViewController:Ctl animated:YES];
}

- (void)modifyGesture:(UIButton *)sender
{
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"gestureNumber"];
    if (str.length > 0) {
        EHGeatureSettingViewController * Ctl = [[EHGeatureSettingViewController alloc] init];
        Ctl.isModifyNum = YES;
        [self.navigationController pushViewController:Ctl animated:YES];
    }
    else
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"还未设置手势密码" message:@"请先设置手势密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            EHGeatureSettingViewController * Ctl = [[EHGeatureSettingViewController alloc] init];
            Ctl.isModifyNum = NO;
            [self.navigationController pushViewController:Ctl animated:YES];
        }];
        [alertView addAction:cancelAction];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
