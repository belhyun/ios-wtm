//
//  WRRoom.h
//  witherest
//
//  Created by 이종현 on 13. 7. 29..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRRoom : NSObject
@property (nonatomic, retain) IBOutlet NSNumber *cntChkUser;
@property (nonatomic, retain) IBOutlet NSNumber *cntJoinUser;
@property (nonatomic, retain) IBOutlet NSString *endDate;
@property (nonatomic, retain) IBOutlet NSString *roomDesc;
@property (nonatomic, retain) IBOutlet NSString *roomManagerId;
@property (atomic, assign) int roomNo;
@property (nonatomic, retain) IBOutlet NSString *roomTitle;
@property (nonatomic, retain) IBOutlet NSString *startDate;
@property (assign,atomic) Boolean isChcked;
-(id) initWithDictionary:(NSDictionary *)dictionary;
@end
