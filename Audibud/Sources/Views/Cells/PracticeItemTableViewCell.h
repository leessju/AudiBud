//
//  PracticeItemTableViewCell.h
//  AudiBud
//
//  Created by 이승주 on 16/08/2018.
//  Copyright © 2018 nicejames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PracticeItemTableViewCell : UITableViewCell

- (void)setData:(NSDictionary *)dicData;

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger curindex;
@property (assign, nonatomic) NSInteger language_type_idx;
@property (assign, nonatomic) NSMutableArray *viewArray;

@end
