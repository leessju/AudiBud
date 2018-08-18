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
#import <AVFoundation/AVFoundation.h>

#import "FileTypeViewController.h"
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
    
    //[GCache setString:@"" forKey:@"_version_"];
    if([[GCache stringForKey:@"_version_"] isEqualToString:@""])
    {
        NSLog(@"************** cache init ************");
        GCSet(@"_version_", @"2018");
        GCSet(@"language_type_idx", @"0");
        GCSet(@"repeat_count", @"3");
        GCSet(@"random_yn", @"0");
        GCSet(@"gap_sec", @"1.0");
    }
    
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    Float32 bufferLength = 0.1;
    [[AVAudioSession sharedInstance] setPreferredIOBufferDuration:bufferLength error:&error];
    
    self.tab_height = 49;
    
    if (IS_IPHONE_X)
        self.tab_height = 75;
    else
        self.tab_height = 49;
    
//    T1ViewController *v1Controller  = [[T1ViewController alloc] initWithNibName:@"T1ViewController" bundle:nil];
//    v1Controller.title = @"Learning Items List";
//    self.t1navigationController     = [[UINavigationController alloc] initWithRootViewController:v1Controller];
    
    FileTypeViewController *v1Controller  = [[FileTypeViewController alloc] initWithNibName:@"FileTypeViewController" bundle:nil];
    v1Controller.title = @"Select Type";
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
