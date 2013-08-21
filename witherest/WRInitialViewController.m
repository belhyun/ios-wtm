//
//  WRInitialViewController.m
//  witherest
//
//  Created by 이종현 on 13. 7. 21..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRInitialViewController.h"

@interface WRInitialViewController ()

@end

@implementation WRInitialViewController

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
    [self performSegueWithIdentifier:@"WRLoginSegue" sender:self];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
