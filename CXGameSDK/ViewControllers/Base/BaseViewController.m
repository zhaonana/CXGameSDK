//
//  BaseViewController.m
//  BXGameSDK1.0
//
//  Created by JZY on 14-1-17.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "PreferencesUtils.h"

// 操作成功
#define SUCCESS 1
// 系统错误
#define SYSTEM_ERROR 2
// 用户不存在
#define USER_NOT_EXIST 8
// 密码错误
#define LOGIN_ERROR 15
// 用户已经存在
#define USER_EXIST 17
// 已经绑定手机号
#define BIND_HAS 18
// 没有绑定手机号
#define UNBIND_MOBILE 19
// 手机号不正确
#define PHONE_MISSMATCH 22
// 验证码不正确
#define CODE_MISSMATCH 23
// 验证码过期
#define CODE_EXPIRED 24
// 新密码与原始密码相同
#define ERR_OLD_NEW_PASSWORD_MISMATCH 31
// 旧密码不正确
#define ERR_PASSWORD_MISMATCH 32
//手机已经被使用
#define PHONE_HAS_BIND 51
// 参数格式不正确
#define PARAMETER_INVALID 100
// 密码必须为6-20个英文字母或数字
#define PARAMETER_PASSWORD_INVALID 111

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveUsers:(UserModel*)user
{
    //还原UserModel数组
    NSString *json = [PreferencesUtils getStringForKey:kUserNames];
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *userArray = [JsonUtil parseUserModelArrayStr:[self parseJsonData:data]];
    if (!userArray) {
        userArray = [[NSMutableArray alloc] init];
    }
    
    //判断是否已经存储
    if(userArray && [userArray count] > 0){
        for (UserModel *mUser in userArray) {
            if([mUser.nick_name isEqualToString:user.nick_name]){
                [userArray removeObject:mUser];
                break;
            }
        }
    }
    
    //存储用户信息
    [userArray addObject:user];
    NSString *usersJson = [JsonUtil toUserArrayJson:userArray];
    [PreferencesUtils putString:kUserNames value:usersJson];
}

- (NSMutableArray*)parseJsonData:(NSData *)data
{
    if (data == nil) {
        return [[NSMutableArray alloc] init];
    }
    NSError *error;
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (jsonArray == nil) {
        return [[NSMutableArray alloc] init];
    }
    return jsonArray;
}

- (void)showToast:(NSInteger)code
{
    NSString *msg;
    switch (code) {
		case SYSTEM_ERROR:
			msg = @"系统错误";
			break;
		case USER_NOT_EXIST:
			msg = @"用户不存在";
			break;
		case LOGIN_ERROR:
			msg = @"密码错误";
			break;
		case USER_EXIST:
			msg = @"用户已经存在";
			break;
		case BIND_HAS:
			msg = @"已经绑定手机号";
			break;
        case UNBIND_MOBILE:
            msg = @"没有绑定手机号";
            break;
		case PHONE_MISSMATCH:
			msg = @"手机号不正确";
			break;
		case CODE_MISSMATCH:
			msg = @"验证码不正确";
			break;
		case CODE_EXPIRED:
			msg = @"验证码过期";
			break;
		case ERR_OLD_NEW_PASSWORD_MISMATCH:
			msg = @"新密码与原始密码相同";
			break;
		case ERR_PASSWORD_MISMATCH:
			msg = @"密码错误";
			break;
        case PHONE_HAS_BIND:
            msg = @"手机号已经被使用";
            break;
		case PARAMETER_INVALID:
			msg = @"参数格式不正确";
			break;        
        case PARAMETER_PASSWORD_INVALID:
            msg = @"密码必须为6-20个英文字母或数字";
            break;
		default:
			msg = @"错误码1001";
    }
    [SVProgressHUD showErrorWithStatus:msg];
}

- (void)resetView
{
    
}

//点击return时触发的事件
- (void)textFiledReturnEditing:(id)sender
{
    [sender resignFirstResponder];
}

#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

// 是否支持转屏
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    switch (self.rootView.screenOrientation) {
        case VERTICAL:
            return UIInterfaceOrientationMaskPortrait;      //竖屏
            break;
        case HORIZONTAL:
            return UIInterfaceOrientationMaskLandscapeLeft; //横屏
            break;
        default:
            break;
    }
}

@end
