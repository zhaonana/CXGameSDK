//
//  CXSDKViewController.h
//  CXGameSDK1.0
//
//  Created by NaNa on 14-1-17.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TYPE_LOGIN 0
#define TYPE_USER_LOGIN 1
#define TYPE_REGISTER 2
#define TYPE_ISBIND_PHONE 3
#define TYPE_CHANGE_PASSWROD 4
#define TYPE_TOURISTS_LOGIN 5
#define TYPE_BIND_PHONE 6
#define TYPE_FORGOT_PASSWORD 7
#define TYPE_RESET_PASSWORD 8

@class CXSDKViewController;

typedef enum {
    VERTICAL,
    HORIZONTAL,
} SDKOrientation;

@protocol LoginCallBack <NSObject>

- (void)loginCallBack:(NSInteger)resultCode userID:(NSString *) userID ticket:(NSString *) ticket;

@end

@interface CXSDKViewController : UIViewController

//横竖屏
@property (nonatomic, assign) SDKOrientation   screenOrientation;
//游戏合作商秘钥
@property (nonatomic, strong) NSString         *cpKey;
//服务器ID
@property (nonatomic, strong) NSString         *serverID;
//应用ID
@property (nonatomic, strong) NSString         *appID;
//登录回调
@property (nonatomic, assign) id<LoginCallBack      > loginDelegate;
@property (nonatomic, strong) UIViewController *controller;

/*
   初始化SDK
 */
- (void)initSDK:(UIViewController*)controller;
- (void)openSDK:(UIViewController *)controller;

/*
 * 关闭SDK
 */
- (void)closeSDK;

/*
 * 按照Tag显示界面()
 */
- (void)showTabByTag:(NSInteger)tag;

@end
