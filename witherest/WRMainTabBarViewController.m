//
//  WRMainTabBarViewController.m
//  witherest
//
//  Created by 이종현 on 13. 7. 10..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRMainTabBarViewController.h"
#import "WRLoginViewController.h"

@interface WRMainTabBarViewController ()

@end

@implementation WRMainTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mobileSvc = [WRMobileService getInstance];
    if(self.mobileSvc.client.currentUser.userId){
        NSLog(@"이미 로그인");
    }else{
        NSLog(@"아직 로그인 되지 않음");
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
