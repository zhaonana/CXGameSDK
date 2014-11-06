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
#import "CXPayParams.h"
#import "InAppRageIAPHelper.h"

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
    [cxVC setAppID:@"10086"];
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
    CXPayParams *params = [[CXPayParams alloc] init];
    params.good_id = @"12";
    params.cp_bill_no = @"123456";
    params.notify_url = @"http://pay.zjszz.173.com/pay!finishOrder.action?aaa=bbb&ccc=ddd";
    params.extra = @"abc2013-05-24";
    
    [[InAppRageIAPHelper sharedHelper] requestOrdersWithParams:params];
}


@end
