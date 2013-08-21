//
//  WRUser.h
//  witherest
//
//  Created by 이종현 on 13. 7. 28..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRUser : NSObject
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userImg;
@property (nonatomic, retain) NSString *userGroup;
@property (nonatomic, retain) NSString *userProfile;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, strong) NSArray *userCategory;
-(id) initWithDictionary:(NSDictionary *)dictionary;
@end
