//
//  WRCalendarViewController.h
//  witherest
//
//  Created by 이종현 on 13. 8. 7..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KalViewController.h"
#import "WRMakeRoomTableViewController.h"

@interface WRCalendarViewController : UIViewController
@property(nonatomic,strong) KalViewController *calendar;
@property (strong, nonatomic) NSString *fromView;
@property (nonatomic, assign) WRMakeRoomTableViewController *delegate;
@end
