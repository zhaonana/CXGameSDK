//
//  Common.h
//  BXGameSDK
//
//  Created by JZY on 14-2-17.
//  Copyright (c) 2014年 jzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "CXSDKViewController.h"

@interface Common : NSObject

+ (UserModel*)getUser;
+ (void)setUser:(UserModel*)mUser;

+ (void)setAppID:(NSString*)appID;
+ (void)setCPKey:(NSString*)cpKey;
+ (void)setServerID:(NSString*)serverID;
+ (void)setSDKOrientation:(SDKOrientation)orientation;
+ (void)setBindPhone:(BOOL)bindPhone;

+ (NSString*)getAppID;
+ (NSString*)getCPKey;
+ (NSString*)getServerID;
+ (SDKOrientation)getSDKOrientation;
+ (BOOL)isBindPhone;

@end
