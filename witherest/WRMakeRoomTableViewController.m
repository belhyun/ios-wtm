//
//  WRMakeRoomTableViewController.m
//  witherest
//
//  Created by 이종현 on 13. 7. 11..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRMakeRoomTableViewController.h"
#import "WRHttpClientInfo.h"
#import "WRHttpClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFJSONRequestOperation.h"
#import "WRMobileService.h"
#import "MBProgressHUD.h"
#import "WRCalendarViewController.h"
#import "Kal.h"
#import "WRCategoryListViewController.h"

@interface WRMakeRoomTableViewController ()
-(void) isDateFormatRight;
-(void) makeAlertView;
@property(nonatomic,strong) NSString *hostUrl;
@property(nonatomic,strong) WRHttpClient *httpClient;

@end

@implementation WRMakeRoomTableViewController
@synthesize roomEndDate = _roomEndDate;
@synthesize selStartDate = _selStartDate;
@synthesize selEndDate = _selEndDate;
@synthesize userCategory = _userCategory;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    self.roomStartDate.text = self.selStartDate;
    self.roomEndDate.text = self.selEndDate;
    if(self.userCategory != nil && [self.userCategory count] != 0){
        WRCategory *category = [self.userCategory objectAtIndex:0];
        self.category.text = category.categoryName;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mobileSvc = [WRMobileService getInstance];
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    self.HUD.delegate = self;
    self.selStartDate = @"방 시작일자";
    self.selEndDate = @"방 종료일자";
    self.category.text = @"카테고리";
    
    self.hostUrl = [[NSString alloc]initWithUTF8String:WR_HTTP_HOST];
    self.httpClient = [WRHttpClient sharedClient:self.hostUrl];

  	// Show the HUD while the provided method executes in a new thread
	//[self.HUD showWhileExecuting:@selector(postRoom) onTarget:self withObject:nil animated:YES];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController.view addSubview:self.HUD];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if(indexPath.row == 2){
        [self performSegueWithIdentifier:@"roomStartDateSegue" sender:self];
        //[self.navigationController pushViewController:calendar animated:YES];
        //[[self navigationController] initWithRootViewController:calendar];
        //[[calendar navigationItem] setHidesBackButton:YES];
        //[self addChildViewController:calendar];
    }
    if(indexPath.row == 3){
        [self performSegueWithIdentifier:@"roomEndDateSegue" sender:self];
        //KalViewController *calendar = [[KalViewController alloc] init];
        //[self.navigationController pushViewController:calendar animated:YES];
    }
    if(indexPath.row == 4){
        [self performSegueWithIdentifier:@"categorySelectSegue" sender:self];
        //KalViewController *calendar = [[KalViewController alloc] init];
        //[self.navigationController pushViewController:calendar animated:YES];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"roomStartDateSegue"]){
        WRCalendarViewController *controller = [segue destinationViewController];
        controller.delegate = self;
        controller.fromView = @"START_DATE";
    }else if ([[segue identifier] isEqualToString:@"roomEndDateSegue"]){
        WRCalendarViewController *controller = [segue destinationViewController];
        controller.delegate = self;
        controller.fromView = @"END_DATE";
    }else if ([[segue identifier] isEqualToString:@"categorySelectSegue"]){
        WRCategoryListViewController *controller = [segue destinationViewController];
        controller.fromView = @"WRMakeRoomTableViewController";
        controller.delegate = self;
    }
}

-(IBAction) submit:(id)sender{
    if([self.roomTitle.text length] == 0){
        [self.mobileSvc makeAlertView:@"스터디방 이름을 입력하세요." :self];
        return;
    }
    else if([self.roomDesc.text length] == 0){
        [self.mobileSvc makeAlertView:@"스터디방 설명을 입력하세요." :self];
        return;
    }
    else if([self.roomStartDate.text length] == 0){
        [self.mobileSvc makeAlertView:@"스터디방 시작일짜를 입력하세요." :self];
        return;
    }
    else if([self.roomEndDate.text length] ==0){
        [self.mobileSvc makeAlertView:@"스터디방 종료일짜를 입력하세요." :self];
        return;
    }
    [self postRoom];
}

-(void)postRoom{
    self.mobileSvc = [WRMobileService getInstance];
    WRCategory *category = [self.userCategory objectAtIndex:0];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.roomTitle.text, @"room_title",
                            self.roomDesc.text, @"room_desc",
                            self.roomEndDate.text, @"end_date",
                            self.roomStartDate.text, @"start_date",
                            [category.categoryNo stringValue], @"category_no",
                            self.mobileSvc.client.currentUser.userId, @"room_manager_no",nil];
    NSString *path = [[NSString alloc] initWithFormat:@"/api/room"];
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"POST" path:path parameters:params];
    [request setValue:self.mobileSvc.client.currentUser.mobileServiceAuthenticationToken forHTTPHeaderField:@"X-ZUMO-AUTH"];
	//[self.navigationController.view addSubview:HUD];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@",JSON);
        if([[JSON objectForKey:@"code"] integerValue] != 100){
            [self.mobileSvc makeAlertView:@"실패" :self];
        }else{
            [self.mobileSvc makeAlertView:@"성공" :self];
        }
        [[self navigationController] popViewControllerAnimated:YES];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    }];
    [operation start];
}

@end
