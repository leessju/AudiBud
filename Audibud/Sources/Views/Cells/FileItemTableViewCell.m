//
//  FileItemCellTableViewCell.m
//  AudiBud
//
//  Created by 이승주 on 15/08/2018.
//  Copyright © 2018 nicejames. All rights reserved.
//

#import "FileItemTableViewCell.h"

@interface FileItemTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) NSDictionary *dicData;

@end

@implementation FileItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setData:(NSDictionary *)dicData
{
    self.dicData = dicData;
    
    if (dicData)
    {
        self.lblTitle.text = dicData[@"f_name"];
        
//        if ([self.dicData[@"brand_image_count"] intValue] > 0)
//        {
//            [self.ivBrand sd_setImageWithURL:[DATA_HELPER imageUrl:self.dicData[@"brand_images"] key:@"brand" size:CGSizeZero]
//                            placeholderImage:nil
//                                     options:0
//                                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//                                    }
//                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//                                   }];
//        }
        
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
