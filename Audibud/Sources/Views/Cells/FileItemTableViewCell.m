//
//  FileItemCellTableViewCell.m
//  AudiBud
//
//  Created by 이승주 on 15/08/2018.
//  Copyright © 2018 nicejames. All rights reserved.
//

#import "FileItemTableViewCell.h"
#import "DefinedHeader.h"

@interface FileItemTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnView;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;
@property (weak, nonatomic) IBOutlet UIView *vBack;


@property (strong, nonatomic) NSDictionary *dicData;

@end

@implementation FileItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.btnDownload moveToX:SCREEN_WIDTH - 60];
    [self.btnView sizeToWidth:SCREEN_WIDTH - 60];
    self.btnDownload.hidden = NO;
    [self.lblTitle sizeToWidth:SCREEN_WIDTH - 70];
    [self.vBack sizeToWidth:SCREEN_WIDTH];
    
    self.vBack.backgroundColor = [UIColor colorWithHexString:@"#fcf6f4"];
}

- (void)setData:(NSDictionary *)dicData
{
    self.dicData = dicData;
    
    self.btnDownload.hidden = NO;
    [self.btnDownload moveToX:SCREEN_WIDTH - 60];
    [self.btnView sizeToWidth:SCREEN_WIDTH - 60];
    self.vBack.backgroundColor = [UIColor colorWithHexString:@"#fcf6f4"];
    
    if (dicData)
    {
        if([self.download_yn isEqualToString:@"Y"])
        {
            self.btnDownload.hidden = YES;
            [self.btnView sizeToWidth:SCREEN_WIDTH];
            self.vBack.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            [self.lblTitle sizeToWidth:SCREEN_WIDTH - 10];
        }

        self.lblTitle.text = dicData[@"f_name"];
    }
}

- (IBAction)onTouch_btnView:(id)sender
{
    if(self.delegate)
    {
        [self.delegate didView:[self.dicData[@"f_idx"] intValue]];
    }
}

- (IBAction)onTouch_btnDownload:(id)sender
{
    if(self.delegate)
    {
        [self.delegate didDownload:[self.dicData[@"f_idx"] intValue] with:self.dicData];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


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


@end
