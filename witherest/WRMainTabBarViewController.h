//
//  WRMainTabBarViewController.h
//  witherest
//
//  Created by 이종현 on 13. 7. 10..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "WRMobileService.h"
#import <WindowsAzureMobileServices/MSClient.h>

@interface WRMainTabBarViewController : UITabBarController<UITextFieldDelegate>
@property (strong, nonatomic) WRMobileService *mobileSvc;
@end
