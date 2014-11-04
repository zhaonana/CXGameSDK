//
//  MainViewController.m
//  BXGameSDK1.0
//
//  Created by JZY on 14-1-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "MainViewController.h"
#import "CXSDKViewController.h"
#import "SVProgressHUD.h"
#import "PayViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actio
- (void)startSDK
{
    CXSDKViewController *cxVC = [[CXSDKViewController alloc] init];
    cxVC.loginDelegate = self;
    [cxVC setAppID:@"10001"];
    [cxVC setCpKey:@"123456"];
    [cxVC setServerID:@"2"];
    [cxVC setScreenOrientation:VERTICAL];
    [cxVC initSDK:self];
}

- (void)loginCallBack:(NSInteger)resultCode userID:(NSString *)userID ticket:(NSString *) ticket
{
    NSString *result = [NSString stringWithFormat:@"登录 resultCode=%ld, userID=%@", (long)resultCode, userID];
    [SVProgressHUD showSuccessWithStatus:result];
}

- (void)startPay
{
    PayViewController *pVC = [[PayViewController alloc] init];
    [self presentViewController:pVC animated:YES completion:nil];
}

@end
