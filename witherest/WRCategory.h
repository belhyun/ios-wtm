//
//  WRCategory.h
//  witherest
//
//  Created by 이종현 on 13. 7. 27..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRCategory : NSObject
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSNumber *roomCnt;
@property (nonatomic, retain) NSNumber *categoryNo;

-(id) initWithDictionary:(NSDictionary *)dictionary;

@end
