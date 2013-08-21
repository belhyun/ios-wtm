//
//  WRCategoryListViewController.m
//  witherest
//
//  Created by 이종현 on 13. 7. 10..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRCategoryListViewController.h"
#import "WRMyRoomListTableViewCell.h"
#import "WRHttpClientInfo.h"
#import "WRHttpClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFJSONRequestOperation.h"
#import "WRMobileService.h"
#import "WRCategory.h"
#import "WRCategoryListTableViewCell.h"
#import "MBProgressHUD.h"
#import "WRProfileUpdateViewController.h"
#import "WRRoomDetailTableViewController.h"
#import "WRRoom.h"
#import "WRMyRoomListViewController.h"
#import "WRMakeRoomTableViewController.h"

@interface WRCategoryListViewController ()
@property (nonatomic, retain) NSArray *categories;
-(void) fetchCategories;
-(void) completeSelect;
@property (nonatomic, strong) WRCategory *selCat;
@property(nonatomic,strong) NSString *hostUrl;
@property(nonatomic,strong) WRHttpClient *httpClient;
@end

@implementation WRCategoryListViewController
@synthesize categories = _categories;
@synthesize fromView = _fromView;
@synthesize delegate = _delegate;
int selectCounter = 0;
int selectMaxNum = 3;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mobileSvc = [WRMobileService getInstance];
    if([self.fromView isEqualToString:@"WRProfileUpdateViewController"]){
        selectMaxNum = 3;
    }else if([self.fromView isEqualToString:@"WRMakeRoomTableViewController"]){
        selectMaxNum = 1;
    }
    
    self.hostUrl = [[NSString alloc]initWithUTF8String:WR_HTTP_HOST];
    self.httpClient = [WRHttpClient sharedClient:self.hostUrl];

    if([self.fromView isEqualToString:@"WRProfileUpdateViewController"] || [self.fromView isEqualToString:@"WRMakeRoomTableViewController"]){
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
    }else{
        self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:self.HUD];
    }
    self.HUD.delegate = self;
	// Show the HUD while the provided method executes in a new thread
	//[self.HUD showWhileExecuting:@selector(fetchCategories) onTarget:self withObject:nil animated:YES];
    [self fetchCategories];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if([self.fromView isEqualToString:@"WRProfileUpdateViewController"] || [self.fromView isEqualToString:@"WRMakeRoomTableViewController"]){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
    
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
        [headerView addSubview:headerLabel];
    
        return headerView;
    }
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if([self.fromView isEqualToString:@"WRProfileUpdateViewController"] || [self.fromView isEqualToString:@"WRMakeRoomTableViewController"]){
        return  50.0;
    }else{
        return 0.0;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"category";
    WRCategoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[WRCategoryListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    WRCategory *category = [self.categories objectAtIndex:indexPath.row
                            ];
    cell.categoryName.text = category.categoryName;
    cell.roomCnt.text = category.roomCnt;
    // Configure the cell...
    [cell setSelected:YES animated:YES];
    return cell;
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


- (void)fetchCategories{
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET" path:@"/api/category" parameters:nil];
    [request setValue:self.mobileSvc.client.currentUser.mobileServiceAuthenticationToken forHTTPHeaderField:@"X-ZUMO-AUTH"];
    [self.HUD show:YES];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self.HUD hide:YES];
        // code for successful return goes here
        NSMutableArray *results = [NSMutableArray array];
        for(id categoryDictionary in [JSON objectForKey:@"categories"]){
            WRCategory *category = [[WRCategory alloc] initWithDictionary:categoryDictionary];
            [results addObject:category];
        }
        self.categories = results;
        [self.tableView reloadData];
        // do something with return data
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        // do something on failure
    }];
    [operation start];
}

-(void) completeSelect{
    //[self performSegueWithIdentifier:@"goProfileUpdateSegue" sender:self];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for(int i=0;i<[self.categories count]; i++){
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [result addObject:self.categories[i]];
        }
    }
    [self.delegate setUserCategory:result];
    selectCounter = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"categoryRoomSegue"]){
        WRMyRoomListViewController *controller = [segue destinationViewController];
        controller.selCat = [self.selCat.categoryNo intValue];
        controller.fromView = @"WRCategoryListViewController";
    }
}
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
    WRCategory *category = [self.categories objectAtIndex:indexPath.row
                            ];
    self.selCat = category;
    if([self.fromView isEqualToString:@"WRProfileUpdateViewController"] || [self.fromView isEqualToString:@"WRMakeRoomTableViewController"]){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType != UITableViewCellAccessoryCheckmark && selectCounter < selectMaxNum){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            selectCounter++;
        }
        else if (selectCounter >= selectMaxNum) return; //Don't do anything if the cell isn't checked and the maximum has been reached
        else{ //If cell is checked and gets selected again, deselect it
            cell.accessoryType = UITableViewCellAccessoryNone;
            selectCounter--;
        }
    }else{
        [self performSegueWithIdentifier:@"categoryRoomSegue" sender:self];
    }
}

@end
