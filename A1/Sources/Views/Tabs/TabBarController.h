#import <UIKit/UIKit.h>
#import "TabBar.h"
//#import "BaseViewController.h"

@class TabBarView;
@class AppDelegate;

@interface TabBarController : UIViewController <TabBarDelegate>
{
    AppDelegate *_del;
	NSArray *_viewControllers;
	UIViewController *_selectedViewController;
	TabBar *_tabBar;
	TabBarView *_tabBarView;
    UIButton *_btnHome;
    NSUInteger _categoryIndex;
	BOOL _visible;
    BOOL _isSelected;

}

- (void)hide:(BOOL)animated;
- (void)show:(BOOL)animated;
- (void)selectedIndex:(NSInteger)index;
- (void)setIndex:(NSUInteger)index;

@property (nonatomic, strong) NSArray *viewCons;
@property (nonatomic, strong) UIViewController *selectedViewController;
@property (nonatomic, strong) TabBar *tabBar;
@property (nonatomic, strong) TabBarView *tabBarView;
@property (nonatomic, strong) UIButton *btnHome;
@property (nonatomic, assign) NSUInteger categoryIndex;
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, strong) UIImageView *ivBadge;
@property (nonatomic, strong) UIImageView *ivFeedBadge;

- (void)setviewCons:(NSArray *)array;

@end
