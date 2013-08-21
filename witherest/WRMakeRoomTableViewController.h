//
//  WRMakeRoomTableViewController.h
//  witherest
//
//  Created by 이종현 on 13. 7. 11..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRMobileService.h"
#import "MBProgressHUD.h"
#import "WRCategory.h"

@interface WRMakeRoomTableViewController : UITableViewController<MBProgressHUDDelegate>
@property (strong, nonatomic) WRMobileService *mobileSvc;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) IBOutlet UITextField *roomTitle;
@property (strong, nonatomic) IBOutlet UITextField *roomDesc;
@property (strong, nonatomic) IBOutlet UILabel *roomStartDate;
@property (strong, nonatomic) IBOutlet UILabel *roomEndDate;
@property (strong, nonatomic) IBOutlet UILabel *category;
@property (strong, nonatomic) NSString *selStartDate;
@property (strong, nonatomic) NSString *selEndDate;
@property (strong, nonatomic) NSArray *userCategory;

-(IBAction) submit:(id)sender;
-(void)postRoom:(NSString *)roomTitle :(NSString *) roomDesc :(NSString *)roomStartDate :(NSString *)roomEndDate;
@end
