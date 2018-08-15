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

@end

@implementation PracticeItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.lblTxt1 sizeToWidth:SCREEN_WIDTH - 20];
    [self.lblTxt2 sizeToWidth:SCREEN_WIDTH - 20];
}

- (void)setData:(NSDictionary *)dicData
{
    if (dicData)
    {
        self.lblTxt1.text = dicData[@"txt_kor"];
        self.lblTxt2.text = dicData[@"txt_eng"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
