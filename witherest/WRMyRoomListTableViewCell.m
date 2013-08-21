//
//  WRMyRoomListTableViewCell.m
//  witherest
//
//  Created by 이종현 on 13. 7. 10..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRMyRoomListTableViewCell.h"

@implementation WRMyRoomListTableViewCell
@synthesize roomImage = _roomImage;
@synthesize roomTitle = _roomTitle;

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
