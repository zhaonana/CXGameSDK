//
//  OtherLoginViewController.m
//  CXGameSDK
//
//  Created by NaNa on 14-10-29.
//  Copyright (c) 2014年 nn. All rights reserved.
//

#import "OtherLoginViewController.h"

@interface OtherLoginViewController () <UIWebViewDelegate, LoginCallBack>

@end

@implementation OtherLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"新浪微博";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = CGRectMake(0, 0, 0, 0);
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            frame = CGRectMake(0, 0, KSCREENHEIGHT, KSCREENWIDTH);
            break;
        case UIInterfaceOrientationLandscapeRight:
            frame = CGRectMake(0, 0, KSCREENHEIGHT, KSCREENWIDTH);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            frame = CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT);
            break;
        default:
            frame = CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT);
            break;
    }
    UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
    [webView setDelegate:self];
    
    NSString *phoneVer = [[UIDevice currentDevice] systemVersion];
    NSString *deviceName = [DeviceInfo getDeviceVersion];
    NSMutableDictionary *infoDic = [USER_DEFAULT objectForKey:INITINFO];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://sdkapi.test.ak.cc/user/threelogin?client=%@&app_id=%@&server_id=%@&device_name=%@&os_version=%@&imei=%@",self.client,[infoDic objectForKey:@"appID"],[infoDic objectForKey:@"serviceID"],deviceName,phoneVer,[DeviceInfo getIDFA]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [self.view addSubview:webView];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButtonClick
- (void)barButtonClick
{
    BaseViewController *mainVC = [[BaseViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;
    
    CXSDKViewController *cxVC = [[CXSDKViewController alloc] init];
    cxVC.loginDelegate = self;
    [cxVC setAppID:@"10086"];
    [cxVC setCpKey:@"123456"];
    [cxVC setServerID:@"2"];
    [cxVC openSDK:self];
    [cxVC showTabByTag:TYPE_LOGIN];
}

#pragma mark - UIWebViewDelegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    if ([url.scheme isEqualToString:@"CXAPI"]) {
        
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSDictionary *dic = @{@"client": self.client};
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [GGNetWork getHttp:@"user/threelogin" parameters:params sucess:^(id responseObj) {
        if (responseObj) {
            NSInteger code = [[responseObj objectForKey:@"code"] intValue];
            if(code == 1){
                NSDictionary *dic = [responseObj objectForKey:@"data"];
                UserModel *user = [JsonUtil parseUserModel:dic];
                
                if (self.rootView.loginDelegate && [self.rootView.loginDelegate respondsToSelector:@selector(loginSuccessedCallBack:userID:ticket:)]) {
                    [self.rootView.loginDelegate loginSuccessedCallBack:code userID:user.user_id ticket:user.ticket];
                }
                
                //保存账户密码
                [self saveUsers:user];
                //设置当前用户信息
                [Common setUser:user];
                //关闭SDK
                [self.rootView closeSDK];
            } else {
                if (self.rootView.loginDelegate && [self.rootView.loginDelegate respondsToSelector:@selector(loginFailedCallBack:)]) {
                    [self.rootView.loginDelegate loginFailedCallBack:code];
                }
                [self showToast:code];
            }
        }
    } failed:^(NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:@"链接失败"];
    }];
}


@end
