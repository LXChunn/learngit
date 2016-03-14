//
//  XPActivityTableViewCell.h
//  XPApp
//
//  Created by iiseeuu on 15/12/29.
//  Copyright © 2015年 ShareMerge. All rights reserved.
//

#import "XPBaseModel.h"
#import "XPBaseTableViewCell.h"
@interface XPActivityTableViewCell : XPBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

- (void)bindModel:(XPBaseModel *)model;

+ (NSInteger)cellHeightWithArray:(NSArray *)images;



- (void)hideen;

- (void)hideenForNeighborhood;

- (void)ForMyPostBindModel:(id)model;

- (void)ForMyPostconfigureStatus;

- (void)ForMyCollectBindModel:(id)model;

- (void)ForMyCollecconfigureStatus;
@end
