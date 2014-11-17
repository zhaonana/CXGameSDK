//
//  MainViewController.m
//  BXGameSDK1.0
//
//  Created by JZY on 14-1-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "MainViewController.h"
#import "CXComPlatformBase.h"
#import "CXInitConfigure.h"
#import "SVProgressHUD.h"
#import "CXPayParams.h"
#import "EBPurchaseHelper.h"

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

#pragma mark - Action
#pragma mark - 初始化SDK
- (void)startSDK
{
    CXInitConfigure *cfg = [[CXInitConfigure alloc] init];
    cfg.appId = @"10009";
    cfg.cpKey = @"123456";
    cfg.serverId = @"2";
    cfg.controller = self;
    [[CXComPlatformBase defaultPlatform] CXInit:cfg];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgoinSuccessedCallBack:) name:LOGIN_SUCCESSED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailedCallBack:) name:LOGIN_FAILED_NOTIFICATION object:nil];
}

#pragma mark - 登录回调
- (void)lgoinSuccessedCallBack:(NSNotification *)notification
{
    NSString *userID = [notification.userInfo objectForKey:@"user_id"];
    NSString *ticket = [notification.userInfo objectForKey:@"ticket"];
    NSString *result = [NSString stringWithFormat:@"登录成功 userID=%@, ticket=%@", userID, ticket];
    [SVProgressHUD showSuccessWithStatus:result];
    NSLog(@"%@",result);
}

- (void)loginFailedCallBack:(NSNotification *)notification
{
    NSString *resultCode = [notification.userInfo objectForKey:@"code"];
    NSString *result = [NSString stringWithFormat:@"登录失败 resultCode=%@", resultCode];
    [SVProgressHUD showErrorWithStatus:result];
    NSLog(@"%@",result);
}

#pragma mark - 开始支付
- (void)startPay
{
    CXPayParams *params = [[CXPayParams alloc] init];
    params.good_id = @"25";
    params.cp_bill_no = @"123456";
    params.notify_url = @"http://pay.zjszz.173.com/pay!finishOrder.action?aaa=bbb&ccc=ddd";
    params.extra = @"abc2013-05-24";
    [[EBPurchaseHelper sharedHelper] setOrdersParams:params];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseSuccessedCallBack:) name:PURCHASE_SUCCESSED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseFailedCallBack:) name:PURCHASE_FAILED_NOTIFICATION object:nil];
}

#pragma mark - 支付回调
- (void)purchaseSuccessedCallBack:(NSNotification *)notification
{
    NSString *productId = [notification.userInfo objectForKey:@"productId"];
    NSString *result = [NSString stringWithFormat:@"Your purchase was successful and the Game Levels Pack %@ is now unlocked for your enjoyment!", productId];
    [SVProgressHUD showSuccessWithStatus:result];
    NSLog(@"%@",result);

}

- (void)purchaseFailedCallBack:(NSNotification *)notification
{
    NSString *resultCode = [notification.userInfo objectForKey:@"resultCode"];
    NSString *errorMessage = [notification.userInfo objectForKey:@"errorMessage"];
    NSString *result = [NSString stringWithFormat:@"Either you cancelled the request or Apple reported a transaction error.Please try again later, or contact the app's customer support for assistance.resultCode=%@, errorMessage=%@", resultCode, errorMessage];
    [SVProgressHUD showErrorWithStatus:result];
    NSLog(@"%@",result);
}

@end
