//
//  WRHttpClient.h
//  witherest
//
//  Created by 이종현 on 13. 7. 9..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#define WR_USER "https://wtm.azure-mobile.net/api/user"
@interface WRHttpClient : AFHTTPClient
+(WRHttpClient *)sharedClient:(NSString *) webAddress;
+(void)downloadingServerImageFromUrl:(UIImageView*)imgView AndUrl:(NSString*)strUrl;
@end
