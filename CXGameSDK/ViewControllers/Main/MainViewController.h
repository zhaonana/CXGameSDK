//
//  MainViewController.h
//  BXGameSDK1.0
//
//  Created by JZY on 14-1-15.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXSDKViewController.h"
#import "BaseViewController.h"

@interface MainViewController : BaseViewController <LoginCallBack>

- (void)startSDK;

- (void)startPay;

@end
