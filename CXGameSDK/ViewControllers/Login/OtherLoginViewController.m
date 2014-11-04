//
//  OtherLoginViewController.m
//  CXGameSDK
//
//  Created by NaNa on 14-10-29.
//  Copyright (c) 2014年 nn. All rights reserved.
//

#import "OtherLoginViewController.h"
#import "SvUDIDTools.h"

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
    
    NSString *urlStr = [NSString stringWithFormat:@"http://sdkapi.test.ak.cc/user/changloginsuccess?client=%@&app_id=%@&server_id=%@&device_name=%@&os_version=%@&imei=%@",self.client,[infoDic objectForKey:@"appID"],[infoDic objectForKey:@"serviceID"],deviceName,phoneVer,[SvUDIDTools UDID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [self.view addSubview:webView];
    [webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
