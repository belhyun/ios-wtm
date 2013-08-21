//
//  WRMobileService.m
//  witherest
//
//  Created by 이종현 on 13. 7. 19..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRMobileService.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import <Foundation/Foundation.h>
#import "KeyChainItemWrapper.h"
#import "WRAppDelegate.h"

@implementation WRMobileService

static WRMobileService *singletonInstance;

+ (WRMobileService*)getInstance{
    if (singletonInstance == nil) {
        singletonInstance = [[super alloc] init];
    }
    return singletonInstance;
}

-(WRMobileService *) init
{
    // TODO
    // Initialize the Mobile Service client with your URL and key
    
    
    // TODO
    // Create an MSTable instance to allow us to work with the TodoItem table
    MSClient *client = [MSClient clientWithApplicationURLString:@"https://wtm.azure-mobile.net/" withApplicationKey:@"wMaoPxwwslHHzDTejLrObxTljWXxvT36"];
    // Add a Mobile Service filter to enable the busy indicator
    self.client = client;
    
    return self;
}

- (void) handleRequest:(NSURLRequest *)request
                  next:(MSFilterNextBlock)onNext
              response:(MSFilterResponseBlock)onResponse {
    NSLog(@"handleRequest");
    onNext(request, ^(NSHTTPURLResponse *response, NSData *data, NSError *error){
        [self filterResponse:response
                     forData:data
                   withError:error
                  forRequest:request
                      onNext:onNext
                  onResponse:onResponse];
    });
}

- (void) filterResponse: (NSHTTPURLResponse *) response
                forData: (NSData *) data
              withError: (NSError *) error
             forRequest:(NSURLRequest *) request
                 onNext:(MSFilterNextBlock) onNext
             onResponse: (MSFilterResponseBlock) onResponse
{
    NSLog(@"filterResponse");
    if (response.statusCode == 401) {
        //[self killAuthInfo];
        //we're forcing custom auth to relogin from the root for now
        if (self.shouldRetryAuth && ![self.authProvider isEqualToString:@"Custom"]) {
            // show the login dialog
            [self.client loginWithProvider:self.authProvider controller:[[[[UIApplication sharedApplication] delegate] window] rootViewController] animated:YES completion:^(MSUser *user, NSError *error) {
                if (error && error.code == -9001) {
                    // user cancelled authentication
                    //Log them out here too
                    [self triggerLogout];
                    return;
                }
                [self saveAuthInfo];
                NSMutableURLRequest *newRequest = [request mutableCopy];
                //Update the zumo auth token header in the request
                [newRequest setValue:self.client.currentUser.mobileServiceAuthenticationToken forHTTPHeaderField:@"X-ZUMO-AUTH"];
                //Add our bypass query string parameter so this request doesn't get a 401
                newRequest = [self addQueryStringParamToRequest:newRequest];
                onNext(newRequest, ^(NSHTTPURLResponse *innerResponse, NSData *innerData, NSError *innerError){
                    [self filterResponse:innerResponse
                                 forData:innerData
                               withError:innerError
                              forRequest:request
                                  onNext:onNext
                              onResponse:onResponse];
                });
            }];
        } else {
            [self triggerLogout];
        }
    }
    else {
        onResponse(response, data, error);
    }
}

-(NSMutableURLRequest *)addQueryStringParamToRequest:(NSMutableURLRequest *)request {
    NSMutableString *absoluteURLString = [[[request URL] absoluteString] mutableCopy];
    NSString *newQuery = @"?bypass=true";
    [absoluteURLString appendString:newQuery];
    [request setURL:[NSURL URLWithString:absoluteURLString]];
    return request;
}


- (void)saveAuthInfo {
    [KeychainItemWrapper createKeychainValue:self.client.currentUser.userId forIdentifier:@"userid"];
    [KeychainItemWrapper createKeychainValue:self.client.currentUser.mobileServiceAuthenticationToken forIdentifier:@"token"];
}

- (void)loadAuthInfo {
    NSString *userid = [KeychainItemWrapper keychainStringFromMatchingIdentifier:@"userid"];
    if (userid) {
        NSLog(@"userid: %@", userid);
        self.client.currentUser = [[MSUser alloc] initWithUserId:userid];
        self.client.currentUser.mobileServiceAuthenticationToken = [KeychainItemWrapper keychainStringFromMatchingIdentifier:@"token"];
    }
}

-(void)triggerLogout {
    [self killAuthInfo];
    WRAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
     UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"WRLoginStoryBoard" bundle:nil];
     UIViewController *viewController = [storyBoard instantiateInitialViewController];
     [appDelegate changeRootViewController:viewController];
}

- (void)killAuthInfo {
    [KeychainItemWrapper deleteItemFromKeychainWithIdentifier:@"userid"];
    [KeychainItemWrapper deleteItemFromKeychainWithIdentifier:@"token"];
    
    for (NSHTTPCookie *value in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:value];
    }
    [self.client logout];
}

-(void)makeAlertView:(NSString *)title
                    :(id)target{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:@"" delegate:target cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
    [alert show];
}
@end
