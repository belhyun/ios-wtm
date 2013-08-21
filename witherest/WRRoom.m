//
//  WRRoom.m
//  witherest
//
//  Created by 이종현 on 13. 7. 29..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRRoom.h"

@implementation WRRoom
-(id) initWithDictionary:(NSDictionary *)dictionary{
    self =  [super init];
    if(self){
        self.roomNo = [[dictionary objectForKey:@"room_no"] integerValue];
        self.roomDesc = [dictionary objectForKey:@"room_desc"];
        self.roomManagerId = [dictionary objectForKey:@"room_manager_id"];
        self.roomTitle = [dictionary objectForKey:@"room_title"];
        self.startDate = [dictionary objectForKey:@"start_date"];
        self.endDate = [dictionary objectForKey:@"end_date"];
        self.cntChkUser = [dictionary objectForKey:@"cnt_chk_user"];
        self.cntJoinUser = [dictionary objectForKey:@"cnt_join_user"];
        self.isChcked = [[dictionary objectForKey:@"is_checked"] boolValue];
    }
    return self;
}

-(BOOL)isEqual:(id)object{
    if(![object isKindOfClass:[WRRoom class]]){
        return NO;
    }
    WRRoom *other = (WRRoom *)object;
    return other.roomNo = self.roomNo;
}

@end
