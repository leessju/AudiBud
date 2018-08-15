//
//  UIView+Move.h

#import <UIKit/UIKit.h>

@interface UIView (Move)

- (void)moveToY:(CGFloat)y;
- (void)moveToX:(CGFloat)x;
- (void)moveToX:(CGFloat)x y:(CGFloat)y;
- (void)sizeToWidth:(CGFloat)width;
- (void)sizeToHeight:(CGFloat)height;
- (void)sizeToWidth:(CGFloat)width height:(CGFloat)height;
- (void)moveToCenterHorizonByView:(UIView *)view;
- (void)moveToCenterVerticalByView:(UIView *)view;

@end
