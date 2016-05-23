//
//  ECTabBarController.m
//  EasyChat
//
//  Created by wanghu on 16/5/8.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "ECTabBarController.h"
#import "ECConverseListViewController.h"
#import "ECFriendsListViewController.h"

@interface ECTabBarController ()

@end

@implementation ECTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ECGlobalBgColor;
    
//    UITabBarItem *appearance = [UITabBarItem appearance];
//    [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
//    
    [self setupChildrenControllers];
}

- (void)setupChildrenControllers
{
    [self addChildViewController:[[ECConverseListViewController alloc] init] imageName:@"tabBar_me_icon" selectedImageName:@"tabBar_me_click_icon" withTilte:@"消息"];
    [self addChildViewController:[[ECFriendsListViewController alloc] init] imageName:@"tabBar_friendTrends_icon" selectedImageName:@"tabBar_friendTrends_click_icon" withTilte:@"好友"];
}

- (void)addChildViewController:(UIViewController *)childController imageName:(NSString *)imageName selectedImageName:(NSString *)selecedImageName withTilte:(NSString *)title
{
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:selecedImageName];
    childController.title = title;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
}

@end
