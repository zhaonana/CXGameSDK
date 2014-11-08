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
#import "CXPayParams.h"
#import "EBPurchaseHelper.h"

@interface MainViewController () <LoginCallBack,PurchaseCallBack>

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
    CXSDKViewController *cxVC = [[CXSDKViewController alloc] init];
    cxVC.loginDelegate = self;
    [cxVC setAppID:@"10086"];
    [cxVC setCpKey:@"123456"];
    [cxVC setServerID:@"2"];
    [cxVC initSDK:self];
}

#pragma mark - 登录回调
- (void)loginSuccessedCallBack:(NSInteger)resultCode userID:(NSString *)userID ticket:(NSString *)ticket
{
    NSString *result = [NSString stringWithFormat:@"登录成功 userID=%@, ticket=%@", userID, ticket];
    [SVProgressHUD showSuccessWithStatus:result];
    NSLog(@"%@",result);
}

- (void)loginFailedCallBack:(NSInteger)resultCode
{
    NSString *result = [NSString stringWithFormat:@"登录失败 resultCode=%d", resultCode];
    NSLog(@"%@",result);
}

#pragma mark - 开始支付
- (void)startPay
{
    CXPayParams *params = [[CXPayParams alloc] init];
    params.good_id = @"12";
    params.cp_bill_no = @"123456";
    params.notify_url = @"http://pay.zjszz.173.com/pay!finishOrder.action?aaa=bbb&ccc=ddd";
    params.extra = @"abc2013-05-24";
 
    [[EBPurchaseHelper sharedHelper] setOrdersParams:params];
}

#pragma mark - 支付回调
- (void)purchaseSuccessedCallBack:(NSString *)productId
{
    NSString *result = [NSString stringWithFormat:@"Your purchase was successful and the Game Levels Pack %@ is now unlocked for your enjoyment!", productId];
    [SVProgressHUD showSuccessWithStatus:result];
    NSLog(@"%@",result);
}

- (void)purchaseFailedCallBack:(NSInteger)resultCode message:(NSString *)errorMessage
{
    NSString *result = [NSString stringWithFormat:@"Either you cancelled the request or Apple reported a transaction error.Please try again later, or contact the app's customer support for assistance.resultCode=%d, errorMessage=%@", resultCode, errorMessage];
    [SVProgressHUD showSuccessWithStatus:result];
    NSLog(@"%@",result);
}

@end
