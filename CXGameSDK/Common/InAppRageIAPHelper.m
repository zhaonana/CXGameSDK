//
//  InAppRageIAPHelper.m
//  CXGameSDK
//
//  Created by NaNa on 14-10-21.
//  Copyright (c) 2014年 nn. All rights reserved.
//

#import "InAppRageIAPHelper.h"

@interface InAppRageIAPHelper ()

@end

@implementation InAppRageIAPHelper

static InAppRageIAPHelper * _sharedHelper;

+ (InAppRageIAPHelper *)sharedHelper
{
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[InAppRageIAPHelper alloc] init];
    return _sharedHelper;
}

- (id)init
{
//    NSSet *productIdentifiers = [NSSet setWithObjects:
//                                 @"com.changxiang60.diamond",
//                                 @"com.changxiang300.diamond",
//                                 @"com.changxiang1980.diamond",
//                                 @"com.changxiang3280.diamond",
//                                 @"com.changxiang6480.diamond",
//                                 nil];
    
    if ((self = [super initWithProductIdentifiers:nil])) {
        
    }
    return self;
}

@end
