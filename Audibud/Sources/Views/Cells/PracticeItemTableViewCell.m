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
@property (weak, nonatomic) IBOutlet UIView *vBack;

@end

@implementation PracticeItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.lblTxt1 sizeToWidth:SCREEN_WIDTH - 20];
    [self.lblTxt2 sizeToWidth:SCREEN_WIDTH - 20];
    //[self.vBack sizeToWidth:SCREEN_WIDTH];
}

- (void)setData:(NSDictionary *)dicData
{
    if (dicData)
    {
        self.lblTxt1.text = dicData[@"txt_kor"];
        self.lblTxt2.text = dicData[@"txt_eng"];
        
        if(self.curindex == self.index)
        {
            self.backgroundColor = [UIColor colorWithHexString:@"#DADADA"];
        }
        else
        {
            self.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
