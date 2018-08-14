//
//  DefinedHeader.h
//  hsm_ios
//
//  Created by James Lee on 2015. 3. 27..
//  Copyright (c) 2015년 James Lee. All rights reserved.
//

#ifndef mbk_DefinedHeader_h
#define mbk_DefinedHeader_h
//#import "AppDelegate.h"
//#import "UIColor+Extension.h"
//#import "UINavigationItem+iOS7Spacing.h"
//#import "UIButton+WebCache.h"
#import <EGOCache/EGOCache.h>
//#import <PureLayout/PureLayout.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
//#import <Google/Analytics.h>
//#import "MFSideMenu.h"
//#import "Toast+UIView.h"
//#import "UIAlertView+Blocks.h"
//#import "UIView+Move.h"
//#import "DataHelper.h"
//#import "ArchiveManager.h"
//#import "Utility.h"
//#import "BizUtility.h"
//#import "Addtions.h"
//#import "SQLiteData.h"
//#import "UIDevice+IdentifierAddition.h"
//#import "UIActionSheet+Blocks.h"
//#import "NSString+MD5Addition.h"
//#import <AudioToolbox/AudioServices.h>
//#import <KakaoOpenSDK/KakaoOpenSDK.h>
//#import "MenuViewController.h"
//#import "MainViewController.h"

#ifdef __llvm__
#pragma GCC diagnostic ignored "-Wdangling-else"
#endif

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEXA(h, a) [UIColor colorWithHex:h alpha:a]
#define MAIN_VIEW_CONTROLLER ((UINavigationController *)((MFSideMenuContainerViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController).centerViewController)
#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_RATE_WIDTH (SCREEN_SIZE.width/375.0f)
#define SCREEN_RATE_HEIGHT (SCREEN_SIZE.height/667.0f)
#define SCREEN_OFFSET_WIDTH (SCREEN_SIZE.width - 375.0f)
#define SCREEN_OFFSET_HEIGHT (SCREEN_SIZE.height - 667.0f)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5  (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6  (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X  (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

//#define DATA_HELPER [DataHelper sharedDataHelper]
//#define UTIL [Utility sharedUtility]
//#define ARCHIVE_MANAGER [ArchiveManager sharedArchiveManager]
//#define SQLITE [SQLiteData sharedSQLiteData]
//#define BIZ_UTILITY [BizUtility sharedUtility]
//#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
//#define WEB_DOMAIN ARCHIVE_MANAGER.http
//#define STORY_BOARD ((AppDelegate *)[UIApplication sharedApplication].delegate).storyboard
//#define G_EVENT(a,b,c,d) [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:a action:b label:c value:d] build]];
//#define G_SCREEN_NAME(a) id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];[tracker set:kGAIScreenName value:a];[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//#define G_TRACKKING(a,b,c,d) [BIZ_UTILITY G_Event:a action:b label:c value:d];
//
//#define DEV_YN 1
//
//#define GOOGLE_PLUS @"171366784987-1unevdctefribfeln6vv1ppndr463v09.apps.googleusercontent.com"

//#define BRAND_NAME              @"beautytalk"
#define BRAND_NAME              @"beautytalk1"
//#define ROOT_URL                @"http://www." BRAND_NAME @".co.kr"
//#define ARTICLE_URL             ROOT_URL @"/m/Article?event_idx=%d"
//#define COUPON_URL              ROOT_URL @"/m/Coupon?coupon_idx=%d&user_idx=%d"
//#define EVENT_BOARD_URL         ROOT_URL @"/m/Event?board_idx=%d"
//#define NOTICE_BOARD_URL        ROOT_URL @"/m/Notice?board_idx=%d"
//#define PRODUCT_URL             ROOT_URL @"/m/ProductDetail?product_idx=%d"



#endif
