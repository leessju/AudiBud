//
//  UIView+Move.m


#import "UIView+Move.h"

@implementation UIView (Move)

- (void)moveToY:(CGFloat)y
{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (void)moveToX:(CGFloat)x
{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)moveToX:(CGFloat)x y:(CGFloat)y
{
    self.frame = CGRectMake(x, y, self.frame.size.width, self.frame.size.height);
}

- (void)sizeToWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)sizeToHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void)sizeToWidth:(CGFloat)width height:(CGFloat)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
}


- (void)moveToCenterHorizonByView:(UIView *)view
{
    self.center = CGPointMake(view.center.x, self.center.y);
}

- (void)moveToCenterVerticalByView:(UIView *)view
{
    self.center = CGPointMake(self.center.x, view.center.y);
}

@end
