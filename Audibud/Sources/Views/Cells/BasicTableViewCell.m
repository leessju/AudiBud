//
//  FileItemCellTableViewCell.m
//  AudiBud
//
//  Created by 이승주 on 15/08/2018.
//  Copyright © 2018 nicejames. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "DefinedHeader.h"

@interface BasicTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) NSDictionary *dicData;

@end

@implementation BasicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setData:(NSString *)title
{
    if (title)
    {
        self.lblTitle.text = title;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
