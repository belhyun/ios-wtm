//
//  WRCalendarViewController.m
//  witherest
//
//  Created by 이종현 on 13. 8. 7..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRCalendarViewController.h"
#import "Kal.h"

@interface WRCalendarViewController ()
-(void)completeSelect;
@end

@implementation WRCalendarViewController
@synthesize delegate = _delegate;

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
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSelectDate:) name:@"DATA_SELECTED" object:nil];
    
    self.calendar = [[KalViewController alloc] init];
    self.calendar.delegate = self;
    [self.calendar.view setFrame:CGRectMake(0,50,self.calendar.view.frame.size.width,self.calendar.view.frame.size.height)];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,30)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, headerView.frame.size.width-120.0, headerView.frame.size.height)];
    headerLabel.textAlignment = UITextAlignmentRight;
    headerLabel.backgroundColor = [UIColor clearColor];
    NSInteger tbHeight = 50;
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tbHeight)];
    tb.translucent = YES;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"완료" style:UIBarButtonItemStyleBordered target:self action:@selector(completeSelect)];
    NSArray *barButton  =   [[NSArray alloc] initWithObjects:flexibleSpace,doneButton,nil];
    [tb setItems:barButton];
    [headerView addSubview:tb];
    barButton = nil;
    [self.view addSubview:self.calendar.view];
    [self.view addSubview:headerView];
	// Do any additional setup after loading the view.
}

-(void)completeSelect{
    NSLog(@"선택된 날짜 : %@",self.calendar.selectedDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *result = [formatter stringFromDate:self.calendar.selectedDate];
    //[self.delegate setRoomStartDate:self.calendar.selectedDate];
    if([self.fromView isEqualToString:@"START_DATE"]){
        [self.delegate setSelStartDate:result];
    }else{
        [self.delegate setSelEndDate:result];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
