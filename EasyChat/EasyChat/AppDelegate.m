//
//  AppDelegate.m
//  EasyChat
//
//  Created by wanghu on 16/5/21.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "AppDelegate.h"
#import "ECLoginViewController.h"
#import "ECTabBarController.h"
#import "EMSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //AppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"tk-person#tkeasychat"];
    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 是否自动登录
    if ([EMClient sharedClient].options.isAutoLogin) {
        self.window.rootViewController = [[ECTabBarController alloc] init];
        
    } else {
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ECLoginViewController alloc] init]];
        self.window.rootViewController = nav;
    }
    
    
    [self.window makeKeyAndVisible];
    return YES;
}
@end
