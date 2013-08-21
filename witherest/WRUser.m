//
//  WRUser.m
//  witherest
//
//  Created by 이종현 on 13. 7. 28..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRUser.h"

@implementation WRUser
-(id) initWithDictionary:(NSDictionary *)dictionary{
    self =  [super init];
    if(self){
        self.userGroup = [dictionary objectForKey:@"user_group"];
        self.userImg = [dictionary objectForKey:@"user_img"];
        self.userName = [dictionary objectForKey:@"user_name"];
        self.userProfile = [dictionary objectForKey:@"user_profile"];
        self.userId = [dictionary objectForKey:@"user_id"];
        self.userCategory = [dictionary objectForKey:@"user_category"];
    }
    return self;
}
@end
