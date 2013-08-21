//
//  WRMobileService.h
//  witherest
//
//  Created by 이종현 on 13. 7. 19..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface WRMobileService : NSObject<MSFilter>
@property (nonatomic,strong) MSClient *client;
@property (nonatomic, strong)   NSString *authProvider;
@property (nonatomic)           BOOL shouldRetryAuth;
@property (nonatomic, strong)   NSString *keychainName;

+(WRMobileService*) getInstance;

- (void) handleRequest:(NSURLRequest *)request
                  next:(MSFilterNextBlock)onNext
              response:(MSFilterResponseBlock)onResponse;
-(void)makeAlertView:(NSString *)title
                    :(id)target;
-(void) saveAuthInfo;
- (void)loadAuthInfo;
- (void)killAuthInfo;
@end
