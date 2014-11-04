//
//  BaseViewController.h
//  BXGameSDK1.0
//
//  Created by JZY on 14-1-17.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXSDKViewController.h"
#import "UserModel.h"
#import "StringUtil.h"
#import "SVProgressHUD.h"
#import "GGNetWork.h"
#import "JsonUtil.h"
#import "Common.h"

#define kUserNames @"user_names"
#define kSaveUser @"save_user"

@interface BaseViewController : UIViewController <UITextFieldDelegate> {
    UIView *_paddingView;
}

@property (nonatomic, strong)CXSDKViewController *rootView;

- (void)showToast:(NSInteger)code;

- (void)saveUsers:(UserModel *)user;

- (void)resetView;

- (void)textFiledReturnEditing:(id)sender;

- (NSMutableArray*)parseJsonData:(NSData *)data;

@end
