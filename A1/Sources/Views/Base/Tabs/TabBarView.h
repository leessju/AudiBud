#import <UIKit/UIKit.h>

@class TabBar;
@class MenuOptionView;
@class MenuDisplayView;

@interface TabBarView : UIView 
{
	UIView *_contentView;
	TabBar *_tabBar;
}

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) TabBar *tabBar;

@end
