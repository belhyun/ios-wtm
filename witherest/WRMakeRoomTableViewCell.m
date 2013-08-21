//
//  WRMakeRoomTableViewCell.m
//  witherest
//
//  Created by 이종현 on 13. 7. 11..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRMakeRoomTableViewCell.h"

@implementation WRMakeRoomTableViewCell

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

- (void)setFrame:(CGRect)frame {
    if (self.superview){
        float cellWidth = 500.0;
        frame.origin.x = (self.superview.frame.size.width - cellWidth) / 2;
        frame.size.width = cellWidth;
    }
    
    [super setFrame:frame];
}

@end
