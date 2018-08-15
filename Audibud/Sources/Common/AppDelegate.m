//
//  AppDelegate.m
//  A1
//
//  Created by 이승주 on 14/08/2018.
//  Copyright © 2018 nicejames. All rights reserved.
//

#import "AppDelegate.h"
#import "SQLiteData.h"

#import "DefinedHeader.h"
#import "RootNavigationController.h"
#import "TabBarController.h"

#import "T1ViewController.h"
#import "T2ViewController.h"
#import "T3ViewController.h"
#import "T4ViewController.h"
#import "T5ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[SQLiteData sharedSQLiteData] clearDatabaseFile];
    [[SQLiteData sharedSQLiteData] checkAndCreateDatabase];
//    [[SQLiteData sharedSQLiteData] dropAndcreateTable];
    
    self.tab_height = 49;
    
    if (IS_IPHONE_X)
        self.tab_height = 75;
    else
        self.tab_height = 49;
    
    T1ViewController *v1Controller  = [[T1ViewController alloc] initWithNibName:@"T1ViewController" bundle:nil];
    v1Controller.title = @"Learning Items List";
    self.t1navigationController     = [[UINavigationController alloc] initWithRootViewController:v1Controller];
    T2ViewController *v2Controller  = [[T2ViewController alloc] initWithNibName:@"T2ViewController" bundle:nil];
    v2Controller.title = @"T2";
    self.t2navigationController     = [[UINavigationController alloc] initWithRootViewController:v2Controller];
    T3ViewController *v3Controller  = [[T3ViewController alloc] initWithNibName:@"T3ViewController" bundle:nil];
    v3Controller.title = @"T3";
    self.t3navigationController     = [[UINavigationController alloc] initWithRootViewController:v3Controller];
    T4ViewController *v4Controller  = [[T4ViewController alloc] initWithNibName:@"T4ViewController" bundle:nil];
    v4Controller.title = @"T4";
    self.t4navigationController     = [[UINavigationController alloc] initWithRootViewController:v4Controller];
    T5ViewController *v5Controller  = [[T5ViewController alloc] initWithNibName:@"T5ViewController" bundle:nil];
    v5Controller.title = @"T5";
    self.t5navigationController     = [[UINavigationController alloc] initWithRootViewController:v5Controller];
    
    self.tabBarController = [[TabBarController alloc] init];
    [self.tabBarController setviewCons:
     [NSArray arrayWithObjects:
      [NSArray arrayWithObjects:
       self.t1navigationController,
       self.t2navigationController,
       self.t3navigationController,
       self.t4navigationController,
       self.t5navigationController,
       nil],
      nil] ];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
