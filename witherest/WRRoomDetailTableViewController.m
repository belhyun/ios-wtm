//
//  WRRoomDetailTableViewController.m
//  witherest
//
//  Created by 이종현 on 13. 7. 31..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRRoomDetailTableViewController.h"
#import "WRHttpClient.h"
#import "WRHttpClientInfo.h"
#import "AFNetworking.h"
#import "WRUser.h"

@interface WRRoomDetailTableViewController ()
-(void)fetchRoomInfo;
-(void)joinRoom;
@property(nonatomic,strong) NSString *hostUrl;
@property(nonatomic,strong) WRHttpClient *httpClient;
@end

@implementation WRRoomDetailTableViewController

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
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    self.HUD.delegate = self;
    
    self.hostUrl = [[NSString alloc]initWithUTF8String:WR_HTTP_HOST];
    self.httpClient = [WRHttpClient sharedClient:self.hostUrl];

    self.roomTitle.text = self.room.roomTitle;
    self.roomDesc.text = self.room.roomDesc;
    self.roomStartDate.text = self.room.startDate;
    self.roomEndDate.text = self.room.endDate;
    if([self.mobileSvc.client.currentUser.userId isEqualToString:self.room.roomManagerId]){
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"수정" style:UIBarButtonSystemItemDone target:nil action:nil];
    }else{
        if(![self.fromView isEqualToString:@"WRMyRoomListViewController"]){
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"참여하기" style:UIBarButtonSystemItemDone target:self action:@selector(joinRoom)];
        }
    }
    if(self.room.isChcked){
        [self.chkBtn removeFromSuperview];
    }
    [self fetchRoomInfo];
    [self.navigationController.view addSubview:self.HUD];
}
-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)fetchUserInfo{
    NSString *path = [[NSString alloc] initWithFormat:@"/api/user"];
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET" path:path parameters:nil];
    [request setValue:self.mobileSvc.client.currentUser.mobileServiceAuthenticationToken forHTTPHeaderField:@"X-ZUMO-AUTH"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //성공시
        if([[JSON objectForKey:@"code"] integerValue] == 100){
            if([[JSON objectForKey:@"checked_user"] count] == 0){
                
            }
        }else{
            
        }
        //[[self navigationController] popViewControllerAnimated:YES];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [operation start];
}
-(void)fetchRoomInfo{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat: @"%d", self.room.roomNo], @"room_no",nil];
    NSString *path = [[NSString alloc] initWithFormat:@"/api/room"];
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET" path:path parameters:params];
    [request setValue:self.mobileSvc.client.currentUser.mobileServiceAuthenticationToken forHTTPHeaderField:@"X-ZUMO-AUTH"];
    [self.HUD show:TRUE];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self.HUD hide:TRUE];
        //성공시
        if([[JSON objectForKey:@"code"] integerValue] == 100){
            if([[JSON objectForKey:@"checked_user"] count] > 0){
                int i=0;
                for(id userDictionary in [JSON objectForKey:@"checked_user"]){
                    WRUser *user = [[WRUser alloc] initWithDictionary:userDictionary];
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10+60*i, 10, 50, 50)];
                    NSString *imageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%d/picture?type=large",[user.userId intValue]];
                    [WRHttpClient downloadingServerImageFromUrl:imgView AndUrl:imageUrl];
                    [self.chkUser addSubview:imgView];
                    //NSString *imgFilepath = [[NSBundle mainBundle] pathForResource:@"1123786142" ofType:@"jpg"];
                    //UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgFilepath];
                    //[imgView setImage:img];
                    //[self.chkUser addSubview:imgView];
                }
            }
        }else{
        }
        //[[self navigationController] popViewControllerAnimated:YES];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    }];
    [operation start];
}

-(void)joinRoom{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat: @"%d", self.room.roomNo], @"room_no",nil];
    NSString *path = [[NSString alloc] initWithFormat:@"/api/user_room"];
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"POST" path:path parameters:params];
    [request setValue:self.mobileSvc.client.currentUser.mobileServiceAuthenticationToken forHTTPHeaderField:@"X-ZUMO-AUTH"];
    [self.HUD show:TRUE];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self.HUD hide:TRUE];
        if([[JSON objectForKey:@"code"] integerValue] != 100){
            [self.mobileSvc makeAlertView:@"조인완료" :self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData"
                                                                object:nil];
            
        }
        //[[self navigationController] popViewControllerAnimated:YES];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    }];
    [operation start];
}

-(IBAction) check:(id)sender{
        NSString *path = [[NSString alloc] initWithFormat:@"/api/user_room?room_no=%d",self.room.roomNo];
        NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"PUT" path:path parameters:nil];
        [request setValue:self.mobileSvc.client.currentUser.mobileServiceAuthenticationToken forHTTPHeaderField:@"X-ZUMO-AUTH"];
        [self.HUD show:YES];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [self.HUD hide:YES];
            if([[JSON objectForKey:@"code"] integerValue] == 100){
                [self.mobileSvc makeAlertView:@"체크완료" :self];
                self.room.isChcked = true;
                [self.chkBtn removeFromSuperview];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData"
                                                                        object:nil];
            }
                //[[self navigationController] popViewControllerAnimated:YES];
            }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            }];
            [operation start];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
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
}

@end
