//
//  Common.m
//  BXGameSDK
//
//  Created by JZY on 14-2-17.
//  Copyright (c) 2014年 jzy. All rights reserved.
//

#import "Common.h"

static UserModel *_user;
static NSString *_appID;                      //应用ID
static NSString *_cpKey;                      //游戏合作商秘钥
static NSString *_serverID;                   //服务器ID
static SDKOrientation _screenOrientation;     //横竖屏
static BOOL _isBindPhone;

@implementation Common

+ (UserModel*) getUser
{
    if (!_user) {
        _user = [[UserModel alloc] init];
    }
    return _user;
}

+ (void) setUser:(UserModel*)mUser
{
    _user = mUser;
}

+ (void) setAppID:(NSString *)appID
{
    _appID = appID;
}

+ (void) setCPKey:(NSString*)cpKey
{
    _cpKey = cpKey;
}

+ (void) setServerID:(NSString*) serverID
{
    _serverID = serverID;
}

+ (void)setSDKOrientation:(SDKOrientation)orientation
{
    _screenOrientation = orientation;
}

+ (void)setBindPhone:(BOOL)bindPhone
{
    _isBindPhone = bindPhone;
}

+ (NSString*)getAppID
{
    return _appID;
}

+ (NSString*)getCPKey
{
    return _cpKey;
}

+ (NSString*)getServerID
{
    return _serverID;
}

+ (SDKOrientation)getSDKOrientation
{
    return _screenOrientation;
}

+ (BOOL)isBindPhone
{
    return _isBindPhone;
}

@end
