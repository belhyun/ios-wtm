//
//  WRMyRoomListViewController.h
//  witherest
//
//  Created by 이종현 on 13. 7. 10..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRMobileService.h"
#import "MBProgressHUD.h"

@interface WRMyRoomListViewController : UITableViewController <MBProgressHUDDelegate>
@property (nonatomic, retain) NSMutableArray *rooms;
@property (strong, nonatomic) WRMobileService *mobileSvc;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSString *fromView;
@property (assign, nonatomic) int sNo;
@property (assign, nonatomic) int eNo;
@property (assign, nonatomic) int curPage;
@property (assign, nonatomic) int totalPage;
@property(assign,atomic) int selCat;
@end
