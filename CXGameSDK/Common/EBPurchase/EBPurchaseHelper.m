//
//  EBPurchaseHelper.m
//  CXGameSDK
//
//  Created by NaNa on 14-11-7.
//  Copyright (c) 2014年 nn. All rights reserved.
//

#import "EBPurchaseHelper.h"
#import "EBPurchase.h"
#import "Common.h"
#import "GGNetWork.h"
#import "SVProgressHUD.h"
#import "BaseViewController.h"
#import "TalkingDataAppCpa.h"

@interface EBPurchaseHelper () <EBPurchaseDelegate> {
    EBPurchase *demoPurchase;
    BOOL        isPurchased;
    NSString    *_product_id;
    NSString    *_order_id;
    int         _amount;
}

@end

@implementation EBPurchaseHelper

static EBPurchaseHelper * _sharedHelper;

+ (EBPurchaseHelper *)sharedHelper
{
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[EBPurchaseHelper alloc] init];
    return _sharedHelper;
}

- (void)setOrdersParams:(CXPayParams *)params
{
    demoPurchase = [[EBPurchase alloc] init];
    demoPurchase.delegate = self;
    isPurchased = NO;
    [self requestOrdersWithParams:params];
}

#pragma mark - requestOrders
- (void)requestOrdersWithParams:(CXPayParams *)CXParams
{
    NSDictionary *dic = @{@"good_id": CXParams.good_id,
                          @"cp_bill_no": CXParams.cp_bill_no,
                          @"notify_url": CXParams.notify_url,
                          @"user_id": [Common getUser].user_id,
                          @"extra": CXParams.extra
                          };
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [GGNetWork getHttp:@"pay/appstory" parameters:params sucess:^(id responseObj) {
        if (responseObj) {
            NSInteger code = [[responseObj objectForKey:@"code"] intValue];
            if (code == 1) {
                NSDictionary *dic = [responseObj objectForKey:@"data"];
                _order_id = [dic objectForKey:@"order_id"];
                _product_id = [dic objectForKey:@"product_id"];
                
                // Request In-App Purchase product info and availability.
                if (![demoPurchase requestProduct:_product_id]) {
                    // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
                }
            } else {
                BaseViewController *baseVC = [[BaseViewController alloc] init];
                [baseVC showToast:code];
            }
        }
    } failed:^(NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:@"链接失败"];
    }];
}

#pragma mark - purchase
- (void)purchaseProduct
{
    // First, ensure that the SKProduct that was requested by
    // the EBPurchase requestProduct method in the viewWillAppear
    // event is valid before trying to purchase it.
    
    if (demoPurchase.validProduct != nil) {
        // Then, call the purchase method.
        
        if (![demoPurchase purchaseProduct:demoPurchase.validProduct]) {
            // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
            UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before making this purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [settingsAlert show];
        }
    }
}

- (void)restorePurchase
{
    // Restore a customer's previous non-consumable or subscription In-App Purchase.
    // Required if a user reinstalled app on same device or another device.
    
    // Call restore method.
    if (![demoPurchase restorePurchase]) {
        // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
        UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before restoring a previous purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [settingsAlert show];
    }
}

#pragma mark -
#pragma mark EBPurchaseDelegate Methods

- (void)requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription
{
    NSLog(@"ViewController requestedProduct");
    
    if (productPrice != nil) {
        // Product is available, so update button title with price.
        _amount = [productPrice intValue] * 100;
        [self purchaseProduct];
        NSLog(@"Buy Game Levels Pack ");
    } else {
        // Product is NOT available in the App Store, so notify user.
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"This In-App Purchase item is not available in the App Store at this time. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [unavailAlert show];
    }
}

- (void)successfulPurchase:(EBPurchase*)ebp identifier:(NSString*)productId receipt:(NSData*)transactionReceipt
{
    NSLog(@"ViewController successfulPurchase");
    
    // Purchase or Restore request was successful, so...
    // 1 - Unlock the purchased content for your new customer!
    // 2 - Notify the user that the transaction was successful.
    
    if (!isPurchased) {
        // If paid status has not yet changed, then do so now. Checking
        // isPurchased boolean ensures user is only shown Thank You message
        // once even if multiple transaction receipts are successfully
        // processed (such as past subscription renewals).
        
        isPurchased = YES;
                
        // 1 - Unlock the purchased content and update the app's stored settings.
        NSString *ticket = [transactionReceipt base64Encoding];
        NSDictionary *dic = @{@"order_id": _order_id,
                              @"product_id": _product_id,
                              @"user_id": [Common getUser].user_id,
                              @"ticket": ticket
                              };
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        [GGNetWork getHttp:@"pay/appstorenotify" parameters:params sucess:^(id responseObj) {
            if (responseObj) {
                NSInteger code = [[responseObj objectForKey:@"code"] intValue];
                if (code == 1) {
                    NSLog(@"验证收据成功~");
                    // 2 - Notify the user that the transaction was successful.
                    if (_purchaseDelegate && [_purchaseDelegate respondsToSelector:@selector(purchaseSuccessedCallBack:)]) {
                        [_purchaseDelegate purchaseSuccessedCallBack:productId];
                    }
                    
                    [TalkingDataAppCpa onPay:[Common getUser].user_id withOrderId:_order_id withAmount:_amount withCurrencyType:@"CNY" withPayType:@"In App Purchases"];
                } else {
                    NSLog(@"验证收据失败~");
                }
            }
        } failed:^(NSString *errorMsg) {
            [SVProgressHUD showErrorWithStatus:@"链接失败"];
        }];
    }
    
}

- (void)failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    NSLog(@"ViewController failedPurchase");
    
    // Purchase or Restore request failed or was cancelled, so notify the user.
    
    if (_purchaseDelegate && [_purchaseDelegate respondsToSelector:@selector(purchaseFailedCallBack:message:)]) {
        [_purchaseDelegate purchaseFailedCallBack:errorCode message:errorMessage];
    }
}

- (void)incompleteRestore:(EBPurchase*)ebp
{
    NSLog(@"ViewController incompleteRestore");
    
    // Restore queue did not include any transactions, so either the user has not yet made a purchase
    // or the user's prior purchase is unavailable, so notify user to make a purchase within the app.
    // If the user previously purchased the item, they will NOT be re-charged again, but it should
    // restore their purchase.
    
    UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:@"Restore Issue" message:@"A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [restoreAlert show];
}

- (void)failedRestore:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    NSLog(@"ViewController failedRestore");
    
    // Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Restore Stopped" message:@"Either you cancelled the request or your prior purchase could not be restored. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
}

@end
