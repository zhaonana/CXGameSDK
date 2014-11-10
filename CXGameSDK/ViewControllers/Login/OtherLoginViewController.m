//
//  OtherLoginViewController.m
//  CXGameSDK
//
//  Created by NaNa on 14-10-29.
//  Copyright (c) 2014年 nn. All rights reserved.
//

#import "OtherLoginViewController.h"

@interface OtherLoginViewController () <UIWebViewDelegate>

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
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.cancelOtherLoginBlock) {
        self.cancelOtherLoginBlock();
    }
}

#pragma mark - UIWebViewDelegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    if ([url.scheme isEqualToString:@"cxapi"]) {
        NSString *jsonStr = [url.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSRange range = [jsonStr rangeOfString:@"{"];
        if (range.location != NSNotFound) {
            jsonStr = [jsonStr substringFromIndex:range.location];
        }
        NSData *jsonData = [jsonStr dataUsingEncoding:NSASCIIStringEncoding];
        NSDictionary *dic = [JsonUtil toArrayOrNSDictionary:jsonData];
        UserModel *user = [JsonUtil parseUserModel:dic];
        
        if (self.loginSuccessedBlock) {
            self.loginSuccessedBlock(user.user_id, user.ticket);
        }

        //保存账户密码
        [self saveUsers:user];
        //设置当前用户信息
        [Common setUser:user];
        //TD
        [TalkingDataAppCpa onLogin:user.user_id];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    return YES;
}

@end
