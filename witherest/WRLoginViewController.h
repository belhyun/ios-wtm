//
//  WRLoginViewController.h
//  witherest
//
//  Created by 이종현 on 13. 7. 5..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "WRMobileService.h"
#import <WindowsAzureMobileServices/MSClient.h>
#import "WRAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface WRLoginViewController : UIViewController<UITextFieldDelegate>
-(IBAction) submit:(id)sender;
@property (strong, nonatomic) WRMobileService *mobileSvc;
@property (strong, nonatomic) WRAppDelegate *appDelegate;
@end
