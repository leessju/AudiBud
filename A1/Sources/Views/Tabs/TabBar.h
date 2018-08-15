#import <UIKit/UIKit.h>

@protocol TabBarDelegate;

@interface TabBar : UIView 

- (void)setSelectedTab:(NSUInteger)index;
- (void)setSelectedTab:(NSUInteger)index animated:(BOOL)animated;
- (void)tabSelected:(NSUInteger)index;
- (void)selectAtCategory:(NSUInteger)categoryIndex;

@property (nonatomic, assign) id <TabBarDelegate> __unsafe_unretained delegate;

@end

@protocol TabBarDelegate
- (void)tabBar:(TabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index;
@end
