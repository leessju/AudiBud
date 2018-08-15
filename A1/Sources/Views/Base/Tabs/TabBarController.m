#import "TabBarController.h"
#import "TabBar.h"
#import "TabBarView.h"
#import "DefinedHeader.h"
#import "DefinedHeader.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation TabBarController
//@synthesize viewControllers         = _viewControllers;
@synthesize selectedViewController  = _selectedViewController;
@synthesize tabBar                  = _tabBar;
@synthesize tabBarView              = _tabBarView;
@synthesize categoryIndex           = _categoryIndex;
@synthesize btnHome                 = _btnHome;
@synthesize ivBadge;
@synthesize ivFeedBadge;

//static NSString *gCategoryName[4] =
//{
//	@"", @"", @"", @""
//};

//static NSString *gCategoryImageNameNor[4] =
//{
//    @"bottom_main_icon01_bus_nor.png", @"bottom_main_icon01_subway_nor.png", @"bottom_main_icon01_nor.png", @"bottom_main_icon01_nor.png"
//};
//
//static NSString *gCategoryImageNamePress[4] =
//{
//    @"bottom_main_icon01_bus_press.png", @"bottom_main_icon01_subway_press.png", @"bottom_main_icon01_press.png", @"bottom_main_icon01_press.png"
//};

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[_selectedViewController viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[_selectedViewController viewDidAppear:animated];
	_visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[_selectedViewController viewWillDisappear:animated];	
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[_selectedViewController viewDidDisappear:animated];
	_visible = NO;
}

- (void)loadView
{
    _isSelected = YES;
	_tabBarView = [[TabBarView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //_tabBarView = [[TabBarView alloc] initWithFrame:[[UIScreen bounds]];
    _tabBarView.backgroundColor = [UIColor clearColor];
	self.view   = _tabBarView;
    
//    if (@available(iOS 11.0, *)) {
//        UIWindow *window = UIApplication.sharedApplication.keyWindow;
//        CGFloat bottomPadding = window.safeAreaInsets.bottom;
//
//        NSLog(@"padding : %f", bottomPadding);
//    }
 
    CGFloat navHeaderGap = 0.0f;
    
    _tabBar             = [[TabBar alloc] initWithFrame:CGRectMake(0,
                                                                   SCREEN_HEIGHT - APP_DEL.tab_height,
                                                                   SCREEN_WIDTH,
                                                                   APP_DEL.tab_height)];
    
    _tabBar.backgroundColor = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
	_tabBar.delegate    = self;
    [self.view addSubview:_tabBar];
    
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5f)];
    vLine.backgroundColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1];
    [_tabBar addSubview:vLine];
    
    _categoryIndex = 0;

//    UIButton *btnCreate = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnCreate setImage:[UIImage imageNamed:@"btn_tap3.png"] forState:UIControlStateNormal];
//    [btnCreate setImage:[UIImage imageNamed:@"btn_tap3_s.png"] forState:UIControlStateHighlighted];
//    btnCreate.frame = CGRectMake(124, self.view.bounds.size.height - 44 + navHeaderGap, 73, 44);
//    [btnCreate addTarget:self action:@selector(onTouch_btnCreate:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnCreate];
    
//    self.ivBadge = [[UIImageView alloc] initWithFrame:CGRectMake(294, self.view.bounds.size.height - 40 + navHeaderGap, 23, 17)];
//    self.ivBadge.image = [UIImage imageNamed:@"badge_new.png"];
//    [self.view addSubview:self.ivBadge];
//    self.ivBadge.hidden = YES;
    
    self.ivFeedBadge = [[UIImageView alloc] initWithFrame:CGRectMake(102, self.view.bounds.size.height - (APP_DEL.tab_height - 9) + navHeaderGap, 23, 17)];
    self.ivFeedBadge.image = [UIImage imageNamed:@"badge_new.png"];
    [self.view addSubview:self.ivFeedBadge];
    self.ivFeedBadge.hidden = YES;

	if (_viewControllers)
	{
		_selectedViewController = nil;
		[self setSelectedViewController:[[_viewControllers objectAtIndex:_categoryIndex] objectAtIndex:0]];
	}
}

- (void)onTouch_btnCreate:(UIButton *)sender 
{
    NSLog(@"create");
    
//    [[DataHelper sharedDataHelper] cancelAll];
//    [_del showCreateView];
    
//    TopicViewController *viewController = [[TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil];
//    [_del.tabBarController presentModalViewController:viewController animated:YES];
//    [viewController release];
}

- (void)selectCategoryByButton:(MenuOptionView *)sender index:(NSUInteger)buttonIndex
{
    [_tabBar selectAtCategory:buttonIndex];
    
//    [_btnHome setImage:[UIImage imageNamed:gCategoryImageNameNor[buttonIndex]] forState:UIControlStateNormal];
//    [_btnHome setImage:[UIImage imageNamed:gCategoryImageNamePress[buttonIndex]] forState:UIControlStateHighlighted];
    
    _categoryIndex = buttonIndex;
    [self tabBar:_tabBar didSelectTabAtIndex:0];
}

- (void)setIndex:(NSUInteger)index
{
    [self tabBar:_tabBar didSelectTabAtIndex:index];
}

- (void)tabBar:(TabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index
{
	UIViewController *vc = [[_viewControllers objectAtIndex:_categoryIndex] objectAtIndex:index];
    
    if (index == 1)
    {
//        if (!self.ivFeedBadge.hidden)
//        {
//            self.ivFeedBadge.hidden = YES;
//        }
    }
    else if (index == 4)
    {
//        if (!self.ivBadge.hidden)
//        {
//            self.ivBadge.hidden = YES;
//        }
    }
	
	if (_selectedViewController == vc)
	{
		if ([_selectedViewController isKindOfClass:[UINavigationController class]])
		{
			[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
		}
	}
	else
	{
		[self setSelectedViewController:vc];
	}
    
//[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:NO];
}

- (void)selectedIndex:(NSInteger)index
{
    UIViewController *vc = [[_viewControllers objectAtIndex:_categoryIndex] objectAtIndex:index];
	
	if (_selectedViewController == vc)
	{
		if ([_selectedViewController isKindOfClass:[UINavigationController class]])
		{
			[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
		}
	}
	else
	{
        UIViewController *oldVC = _selectedViewController;
        
        if (_selectedViewController != vc)
        {
            _selectedViewController = vc;
            
            if (_visible)
            {
                [oldVC viewWillDisappear:NO];
                [_selectedViewController viewWillAppear:NO];
            }
            
            self.tabBarView.contentView = vc.view;
            
            [(UINavigationController *)vc popToRootViewControllerAnimated:NO];
            
            if (_visible)
            {
                [oldVC viewDidDisappear:NO];
                [_selectedViewController viewDidAppear:NO];
            }
            
            [_tabBar tabSelected:[[_viewControllers objectAtIndex:_categoryIndex] indexOfObject:vc]];
        }

	}
}

- (void)setviewCons:(NSArray *)array
{
	self.selectedIndex = 0;
	
	if (array != _viewControllers)
	{
		_viewControllers = array;
		
		if (_viewControllers != nil)
		{
			[self setSelectedViewController:[[_viewControllers objectAtIndex:_categoryIndex] objectAtIndex:0]];
		}
	}
}

- (void)setSelectedViewController:(UIViewController *)vc
{
	UIViewController *oldVC = _selectedViewController;
	
	if (_selectedViewController != vc)
	{
		_selectedViewController = vc;
		
		if (_visible)
		{
			[oldVC viewWillDisappear:NO];
			[_selectedViewController viewWillAppear:NO];
		}
		
		self.tabBarView.contentView = vc.view;
		
		if (_visible)
		{
			[oldVC viewDidDisappear:NO];
			[_selectedViewController viewDidAppear:NO];
		}
		
		[_tabBar tabSelected:[[_viewControllers objectAtIndex:_categoryIndex] indexOfObject:vc]];
	}
}

- (NSUInteger)selectedIndex 
{
	return [[_viewControllers objectAtIndex:_categoryIndex] indexOfObject:_selectedViewController];
}

- (void)setSelectedIndex:(NSUInteger)index
{
	if ([[_viewControllers objectAtIndex:_categoryIndex] count] > index)
	{
		_selectedViewController = [[_viewControllers objectAtIndex:_categoryIndex] objectAtIndex:index];
	}
}

- (void)hide:(BOOL)animated
{
	if (animated)
	{
		[UIView animateWithDuration:0.3
						 animations: ^ {
							 [_tabBar setAlpha:0];
						 }
						 completion: ^ (BOOL finished) {
							 _tabBar.hidden = YES;
							 [_tabBarView setNeedsLayout];
						 }];
	}
	else
	{
		[_tabBar setAlpha:0];
		_tabBar.hidden = YES;
		[_tabBarView setNeedsLayout];
	}
}

- (void)show:(BOOL)animated
{
	if (animated)
	{
		[UIView animateWithDuration:0.3
						 animations: ^ {
							 _tabBar.hidden = NO;
							 [_tabBar setAlpha:1];
						 }
						 completion: ^ (BOOL finished) {
							 [_tabBarView setNeedsLayout];
						 }];
	}
	else
	{
		[_tabBar setAlpha:1];
		_tabBar.hidden = NO;
		[_tabBarView setNeedsLayout];
	}
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}

@end
