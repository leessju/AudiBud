//
//  FileItemCellTableViewCell.h
//  AudiBud
//
//  Created by 이승주 on 15/08/2018.
//  Copyright © 2018 nicejames. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FileItemTableViewCellDelegate <NSObject>

- (void)didDownload:(NSUInteger)f_idx;
- (void)didView:(NSUInteger)f_idx;;

@end

@interface FileItemTableViewCell : UITableViewCell

- (void)setData:(NSDictionary *)dicData;
@property (assign, nonatomic) id<FileItemTableViewCellDelegate> delegate;

@end
