//
//  WRProfileUpdateViewController.h
//  witherest
//
//  Created by 이종현 on 13. 8. 1..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRMobileService.h"
#import "MBProgressHUD.h"

@interface WRProfileUpdateViewController : UITableViewController
@property (nonatomic,strong) IBOutlet UITextField *userTech;
@property (nonatomic,strong) IBOutlet UIImageView *image;
@property (nonatomic,strong) IBOutlet UILabel *userCatLabel;
@property (nonatomic,strong) NSArray *userCategory;
@property (nonatomic,strong) IBOutlet UITextField *userName;
@property (nonatomic,strong) IBOutlet UITextField *userEmail;
@property (nonatomic,strong) IBOutlet UITextField *userProfile;
@property (strong, nonatomic) WRMobileService *mobileSvc;
@property (strong, nonatomic) MBProgressHUD *HUD;
-(IBAction) modify:(id)sender;
@end
