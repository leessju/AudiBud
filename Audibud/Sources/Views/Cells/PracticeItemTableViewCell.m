//
//  PracticeItemTableViewCell.m
//  AudiBud
//
//  Created by 이승주 on 16/08/2018.
//  Copyright © 2018 nicejames. All rights reserved.
//

#import "PracticeItemTableViewCell.h"
#import "DefinedHeader.h"

@interface PracticeItemTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblTxt1;
@property (weak, nonatomic) IBOutlet UILabel *lblTxt2;
@property (strong, nonatomic) UILabel *lblC;

@end

@implementation PracticeItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.lblTxt1 sizeToWidth:SCREEN_WIDTH - 30];
    [self.lblTxt2 sizeToWidth:SCREEN_WIDTH - 30];
    
    self.lblC = [[UILabel alloc] init];
    [self.lblC setFont:[UIFont systemFontOfSize:12.0f]];
    self.lblC.textColor = [UIColor redColor];
    self.lblC.frame = CGRectMake(SCREEN_WIDTH - 25, 70, 40, 30);
    self.lblC.backgroundColor= [UIColor clearColor];
    self.lblC.userInteractionEnabled = NO;
    //self.lblC.text= @"TEST";
    [self.contentView addSubview:self.lblC];
}

- (void)setData:(NSDictionary *)dicData
{
    if (dicData)
    {
        NSUInteger p_idx  = [dicData[@"p_idx"] intValue];
        self.lblTxt1.text = dicData[@"txt_kor"];
        self.lblTxt2.text = dicData[@"txt_eng"];
        self.lblC.text = @"";
        
        if(self.curindex == self.index)
        {
            self.backgroundColor = [UIColor colorWithHexString:@"#f7f1db"];
        }
        else
        {
            self.backgroundColor = [UIColor whiteColor];
        }
        
        if (self.language_type_idx == 0)
        {
            self.lblTxt1.hidden = NO;
            self.lblTxt2.hidden = YES;
            
            [self.lblTxt1 moveToY:10];
            [self.lblTxt1 sizeToHeight:80];
        }
        else if (self.language_type_idx == 1)
        {
            self.lblTxt1.hidden = YES;
            self.lblTxt2.hidden = NO;
            
            [self.lblTxt2 moveToY:10];
            [self.lblTxt2 sizeToHeight:80];
        }
        else if (self.language_type_idx == 2)
        {
            self.lblTxt1.hidden = NO;
            self.lblTxt2.hidden = NO;
            
            [self.lblTxt1 moveToY:10];
            [self.lblTxt1 sizeToHeight:38];
            [self.lblTxt2 moveToY:51];
            [self.lblTxt2 sizeToHeight:38];
            //            9, 10, 38
            //            0, 51, 30
        }
        else if (self.language_type_idx == 3)
        {
            self.lblTxt1.hidden = YES;
            self.lblTxt2.hidden = YES;
            [self.lblTxt1 moveToY:10];
            [self.lblTxt1 sizeToHeight:38];
            [self.lblTxt2 moveToY:51];
            [self.lblTxt2 sizeToHeight:38];
        }
        
        if(self.viewArray)
        {
            for (NSDictionary *d in self.viewArray)
            {
                if(p_idx == [d[@"p_idx"] intValue])
                {
                    //NSLog(@"_______ p_idx %d, c : %d", p_idx, [d[@"c"] intValue]);
                    self.lblC.text = @([d[@"c"] intValue]).stringValue;
                    break;
                }
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
