//
//  IAPHelper.m
//  CXGameSDK
//
//  Created by NaNa on 14-10-21.
//  Copyright (c) 2014年 nn. All rights reserved.
//

#import "IAPHelper.h"
#import "GGNetWork.h"
#import "SVProgressHUD.h"
#import "Common.h"

@interface IAPHelper () {
    NSString *_product_id;
    NSString *_order_id;
}

@end

@implementation IAPHelper 

- (void)requestProducts
{
    _request = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _request.delegate = self;
    [_request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Received products results...");
    self.products = response.products;
    self.request = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    if ((self = [super init])) {
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        NSMutableSet * purchasedProducts = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [purchasedProducts addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            }
            NSLog(@"Not purchased: %@", productIdentifier);
        }
        self.purchasedProducts = purchasedProducts;
        
    }
    return self;
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    NSString *ticket = [transaction.transactionReceipt base64Encoding];
    NSDictionary *dic = @{@"order_id": _order_id,
                          @"product_id": _product_id,
                          @"user_id": [Common getUser].user_id,
                          @"ticket": ticket
                          };
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [GGNetWork getHttp:@"pay/appstorynotify" parameters:params sucess:^(id responseObj) {
        if (responseObj) {
            NSInteger code = [[responseObj objectForKey:@"code"] intValue];
            if (code == 1) {
                NSLog(@"验证收据成功~");
                switch (transaction.transactionState) {
                    case SKPaymentTransactionStatePurchased:
                        [self provideContent:transaction.payment.productIdentifier];
                        break;
                    case SKPaymentTransactionStateRestored:
                        [self provideContent:transaction.originalTransaction.payment.productIdentifier];
                        break;
                    default:
                        break;
                }
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
            } else {
                NSLog(@"验证收据失败~");
            }
        }
    } failed:^(NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:@"链接失败"];
    }];
}

- (void)provideContent:(NSString *)productIdentifier
{
    NSLog(@"Toggling flag for: %@", productIdentifier);
    
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_purchasedProducts addObject:productIdentifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:productIdentifier];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"completeTransaction...");
    
    [self recordTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction...");
    
    [self recordTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)buyProductIdentifier:(NSString *)productIdentifier
{
    NSLog(@"Buying %@...", productIdentifier);
    
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

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
                [self buyProductIdentifier:_product_id];
            } else {
                //                [self showToast:code];
            }
        }
    } failed:^(NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:@"链接失败"];
    }];
}

@end
