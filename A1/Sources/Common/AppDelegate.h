//
//  AppDelegate.h
//  A1
//
//  Created by 이승주 on 14/08/2018.
//  Copyright © 2018 nicejames. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabBarController;
@class RootNavigationController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) CGFloat tab_height;

@property (strong, nonatomic) TabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *t1navigationController;
@property (strong, nonatomic) UINavigationController *t2navigationController;
@property (strong, nonatomic) UINavigationController *t3navigationController;
@property (strong, nonatomic) UINavigationController *t4navigationController;
@property (strong, nonatomic) UINavigationController *t5navigationController;


@end

