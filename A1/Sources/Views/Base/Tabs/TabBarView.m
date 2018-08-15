#import "TabBarView.h"
#import "TabBar.h"

@implementation TabBarView

- (void)setTabBar:(TabBar *)aTabBar
{
	[_tabBar removeFromSuperview];
	_tabBar = aTabBar;
	[self addSubview:_tabBar];
    _tabBar.backgroundColor = [UIColor clearColor];
}

- (void)setContentView:(UIView *)aContentView
{
	[_contentView removeFromSuperview];
	_contentView = aContentView;
	_contentView.frame = CGRectMake(0,
                                    0,
                                    self.bounds.size.width,
                                    self.bounds.size.height - self.tabBar.bounds.size.height);

	[self addSubview:_contentView];
	[self sendSubviewToBack:_contentView];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	CGRect rect = _contentView.frame;
	
	if (_tabBar.hidden)
	{
		rect.size.height = self.bounds.size.height;
	}
	else
	{
		rect.size.height = self.bounds.size.height - _tabBar.bounds.size.height;
	}
	_contentView.frame = rect;
	[_contentView layoutSubviews];
}

@end
