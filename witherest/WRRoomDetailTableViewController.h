//
//  WRRoomDetailTableViewController.h
//  witherest
//
//  Created by 이종현 on 13. 7. 31..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRRoom.h"
#import "WRMobileService.h"
#import "MBProgressHUD.h"

@interface WRRoomDetailTableViewController : UITableViewController<MBProgressHUDDelegate>
@property(nonatomic,strong) IBOutlet UILabel *roomTitle;
@property(nonatomic,strong) IBOutlet UILabel *roomDesc;
@property(nonatomic,strong) IBOutlet UILabel *roomStartDate;
@property(nonatomic,strong) IBOutlet UILabel *roomEndDate;
@property(nonatomic,strong) IBOutlet UIButton *chkBtn;
@property(nonatomic,strong) IBOutlet UIView *chkUser;
@property (strong, nonatomic) WRMobileService *mobileSvc;
@property(nonatomic,strong) WRRoom *room;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSString *fromView;
-(IBAction) check:(id)sender;
@end
