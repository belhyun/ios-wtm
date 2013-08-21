//
//  WRCategoryListViewController.h
//  witherest
//
//  Created by 이종현 on 13. 7. 10..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRMobileService.h"
#import "MBProgressHUD.h"

@interface WRCategoryListViewController : UITableViewController <MBProgressHUDDelegate>

@property (strong, nonatomic) WRMobileService *mobileSvc;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSString *fromView;
@property (nonatomic, assign) id delegate;
@end
