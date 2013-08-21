//
//  WRCategoryListTableViewCell.m
//  witherest
//
//  Created by 이종현 on 13. 7. 27..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRCategoryListTableViewCell.h"

@implementation WRCategoryListTableViewCell
@synthesize categoryName = _categoryName;
@synthesize roomCnt = _roomCnt;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
