#import "RootNavigationController.h"
//#import "Utility.h"
#import "TabBarController.h"
//#import "AppDelegate.h"

@interface RootNavigationController()

@end

@implementation RootNavigationController

- (id)init
{
	if (self = [super init])
	{
        [self.navigationController setNavigationBarHidden:YES];
	}
	return self;
}

- (void)popViewController:(UIButton*)button
{
	[self popViewControllerAnimated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
	if ([self.viewControllers count] <= 2)
	{
		if (animated)
		{
			CATransition *transition	= [CATransition animation];
			transition.duration			= 0.5;
			transition.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			transition.type				= kCATransitionFade;
//			[self.backButton.layer addAnimation:transition forKey:nil];
		}
		
//		self.backButton.hidden = YES;
	}
	
	UIViewController *viewController = [self.viewControllers objectAtIndex:([self.viewControllers count] - 2)];
	
	if (viewController.hidesBottomBarWhenPushed)
	{
		[self.cTabBarController hide:animated];
	}
	else
	{
		[self.cTabBarController show:animated];
	}
	
	return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
	UIViewController *viewController = [self.viewControllers objectAtIndex:0];
	
	if (viewController.hidesBottomBarWhenPushed)
	{
		[self.cTabBarController hide:animated];
	}
	else
	{
		[self.cTabBarController show:animated];
	}
	
	return [super popToRootViewControllerAnimated:NO];
}

//- (void)presentModalViewController:(UIViewController *)viewController animated:(BOOL)animated 
//{
////#
////	AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
////	[appDelegate.tabBarController presentModalViewController:viewController animated:animated];
//}

- (void)dismiss:(id)sender 
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
