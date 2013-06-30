//
//  EiwaAppDelegate.m
//  EIWA
//  最初に呼ばれるクラス
//  Created by 菅澤 英司 on 2012/12/25.
//  Copyright (c) 2012年 菅澤 英司. All rights reserved.
//

#import "EiwaAppDelegate.h"
#import "EiwaViewController.h"

@implementation EiwaAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    

    self.viewController = [[EiwaViewController alloc] init];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self.viewController applicationWillEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end
