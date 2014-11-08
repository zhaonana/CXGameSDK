//
//  EBPurchaseHelper.h
//  CXGameSDK
//
//  Created by NaNa on 14-11-7.
//  Copyright (c) 2014年 nn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXPayParams.h"

/**
 *  支付协议
 */
@protocol PurchaseCallBack <NSObject>

/**
 *  支付成功
 *
 *  @param productId 商品ID
 */
- (void)purchaseSuccessedCallBack:(NSString *)productId;
/**
 *  支付失败
 *
 *  @param resultCode   支付失败错误码
 *  @param errorMessage 支付失败错误信息
 */
- (void)purchaseFailedCallBack:(NSInteger)resultCode message:(NSString *)errorMessage;

@end

@interface EBPurchaseHelper : NSObject

/**
 *  支付代理
 */
@property (nonatomic, assign) id<PurchaseCallBack> purchaseDelegate;

/**
 *  创建支付
 *
 *  @return 支付对象
 */
+ (EBPurchaseHelper *)sharedHelper;
/**
 *  设置支付参数
 *
 *  @param params 支付参数
 */
- (void)setOrdersParams:(CXPayParams *)params;

@end
