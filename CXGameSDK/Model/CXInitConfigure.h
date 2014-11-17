//
//  CXInitConfigure.h
//  CXGameSDK
//
//  Created by NaNa on 14-11-14.
//  Copyright (c) 2014年 nn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXInitConfigure : NSObject

/**
 *  应用ID
 */
@property (nonatomic, copy) NSString *appId;
/**
 *  游戏合作商秘钥
 */
@property (nonatomic, copy) NSString *cpKey;
/**
 *  服务器ID
 */
@property (nonatomic, copy) NSString *serverId;
/**
 *  界面
 */
@property (nonatomic, strong) UIViewController *controller;

@end
