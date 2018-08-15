#import "TabBar.h"

#define NumberOfTabButtons 5
#define NumberOfCategory 1
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface TabBar()

@property (nonatomic, assign) NSUInteger categoryIndex;

@end

@implementation TabBar

static NSString *gButtonImages[NumberOfCategory][NumberOfTabButtons][3] =
{
    {
        {@"tab_btn1_nor", @"tab_btn1_pre", @"tab_btn1_pre"},
        {@"tab_btn2_nor", @"tab_btn2_pre", @"tab_btn2_pre"},
        {@"tab_btn3_nor", @"tab_btn3_pre", @"tab_btn3_pre"},
        {@"tab_btn4_nor", @"tab_btn4_pre", @"tab_btn4_pre"},
        {@"tab_btn5_nor", @"tab_btn5_pre", @"tab_btn5_pre"},
    }
};

- (id)initWithFrame:(CGRect)frame
{
    CGPoint gButtonOrigins[NumberOfCategory][NumberOfTabButtons] =
    {
        {
            {0, 0},{(SCREEN_WIDTH/5)*1, 0},{(SCREEN_WIDTH/5)*2, 0},{(SCREEN_WIDTH/5)*3, 0},{(SCREEN_WIDTH/5)*4, 0}
        }
    };
    
    self = [super initWithFrame:frame];
    
    if (self)
	{
        self.backgroundColor = [UIColor clearColor];
        
        for (int j = 0; j < NumberOfCategory; j++) 
        {
            UIView *vwContainer = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,49)];
            vwContainer.backgroundColor = [UIColor clearColor];
            
            for (int i = NumberOfTabButtons - 1; i >= 0; i--)
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(gButtonOrigins[j][i].x,gButtonOrigins[j][i].y,(SCREEN_WIDTH/5),49);
                //button.contentMode = UIViewContentMod;
                [button setImage:[UIImage imageNamed:gButtonImages[j][i][1]] forState:UIControlStateHighlighted];
                //[button setBackgroundImage:[UIImage imageNamed:gButtonImages[j][i][1]] forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i+1;
                
                [vwContainer addSubview:button];
                
//                NSLog(@"button : %@", NSStringFromCGRect(button.frame));
            }
            
            vwContainer.tag = 1000 * (j + 1);
            [self addSubview:vwContainer];
            vwContainer.hidden = YES;
        }
        
        [self viewWithTag:1000].hidden = NO;
    }
    
    return self;
}

- (void)selectAtCategory:(NSUInteger)categoryIndex 
{
    self.categoryIndex = categoryIndex;
    
    for (int j = 0; j < NumberOfCategory; j++) 
    {
        [self viewWithTag:1000 * (j + 1)].hidden = YES;
    }
    
    [self viewWithTag:1000 * (categoryIndex + 1)].hidden = NO;
}

- (void)buttonPushed:(UIButton*)button
{
	[self setSelectedTab:(button.tag - 1)];
}

- (void)setSelectedTab:(NSUInteger)index animated:(BOOL)animated
{
    [self tabSelected:index];
    [self.delegate tabBar:self didSelectTabAtIndex:index];
}

- (void)setSelectedTab:(NSUInteger)index
{
	[self setSelectedTab:index animated:YES];
}

- (void)tabSelected:(NSUInteger)index
{
	for (int i = 0; i < NumberOfTabButtons; i++)
	{
		UIButton *button = (UIButton *)[[self viewWithTag:1000 * (_categoryIndex + 1)] viewWithTag:(i + 1)];

		if (i == index)
		{
			[button setImage:[UIImage imageNamed:gButtonImages[_categoryIndex][i][2]] forState:UIControlStateNormal];
            //[button setBackgroundImage:[UIImage imageNamed:gButtonImages[_categoryIndex][i][2]] forState:UIControlStateNormal];
		}
		else
		{
			[button setImage:[UIImage imageNamed:gButtonImages[_categoryIndex][i][0]] forState:UIControlStateNormal];
            //[button setBackgroundImage:[UIImage imageNamed:gButtonImages[_categoryIndex][i][0]] forState:UIControlStateNormal];
		}
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
}

- (void)setFrame:(CGRect)rect
{
	[super setFrame:rect];
	[self setNeedsDisplay];
}

@end
