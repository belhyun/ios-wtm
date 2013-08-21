//
//  WRCategory.m
//  witherest
//
//  Created by 이종현 on 13. 7. 27..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRCategory.h"

@implementation WRCategory
@synthesize categoryName = _categoryName;
@synthesize categoryNo = _categoryNo;
@synthesize roomCnt = _roomCnt;


-(id) initWithDictionary:(NSDictionary *)dictionary{
    self =  [super init];
    if(self){
        self.categoryName = [dictionary objectForKey:@"category_name"];
        self.roomCnt = [[dictionary objectForKey:@"room_cnt"] stringValue];
        self.categoryNo = [dictionary objectForKey:@"category_no"];
    }
    
    return self;
}

@end
