//
//  WRMyRoomListViewController.m
//  witherest
//
//  Created by 이종현 on 13. 7. 10..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRMyRoomListViewController.h"
#import "WRMyRoomListTableViewCell.h"
#import "WRLoginViewController.h"
#import "WRHttpClientInfo.h"
#import "WRHttpClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFJSONRequestOperation.h"
#import "WRMobileService.h"
#import "WRRoom.h"
#import "WRRoomDetailTableViewController.h"

const int kLoadingCellTag = 1273;

@interface WRMyRoomListViewController ()
-(void) fetchRooms;
-(void) fetchCategoryRooms; 
-(void) reloadData:(NSNotification *)notif;
@property(nonatomic,strong) NSString *hostUrl;
@property(nonatomic,strong) WRHttpClient *httpClient;
@end

@implementation WRMyRoomListViewController
@synthesize rooms = _rooms;
@synthesize fromView = _fromView;

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
    self.curPage = 1;
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    self.HUD.delegate = self;
    self.rooms = [NSMutableArray array];
    self.mobileSvc = [WRMobileService getInstance];
    self.curPage = 1;
    
    self.hostUrl = [[NSString alloc]initWithUTF8String:WR_HTTP_HOST];
    self.httpClient = [WRHttpClient sharedClient:self.hostUrl];

    if([self.fromView isEqualToString:@"WRCategoryListViewController"]){
        //[self.HUD showWhileExecuting:@selector(fetchCategoryRooms) onTarget:self withObject:nil animated:YES];
        [self fetchCategoryRooms];
    }else{
        //[self.HUD showWhileExecuting:@selector(fetchRooms) onTarget:self withObject:nil animated:YES];
        [self fetchRooms];
    }

    [self.navigationController.view addSubview:self.HUD];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"reloadData"
                                               object:nil];
}
-(void) reloadData:(NSNotification *)notif{
    [self fetchRooms];
}
-(void)viewWillAppear:(BOOL)animated{
	// Show the HUD while the provided method executes in a new thread
}

- (void)fetchCategoryRooms{
    NSMutableString * fetchUrl = [[NSMutableString alloc] initWithString:@"/api/category_room"];
    [fetchUrl appendString:[NSMutableString stringWithFormat:@"?s_no=%d&e_no=%d&category_no=%d",10*self.curPage-9,(10*self.curPage-9)+9,self.selCat]];
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET" path:fetchUrl parameters:nil];
    [request setValue:self.mobileSvc.client.currentUser.mobileServiceAuthenticationToken forHTTPHeaderField:@"X-ZUMO-AUTH"];
    [self.HUD show:TRUE];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self.HUD hide:TRUE];
        if([[[JSON objectForKey:@"code"] stringValue] isEqualToString:@"100"]){
            self.totalPage = [[JSON objectForKey:@"room_cnt"] intValue]/10;
            for(id roomDictionary in [JSON objectForKey:@"room"]){
                WRRoom *room = [[WRRoom alloc] initWithDictionary:roomDictionary];
                [self.rooms addObject:room];
            }
            [self.tableView reloadData];
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code     for failed request goes here
    }];
    [operation start];
}

- (void)fetchRooms{
    NSMutableString * fetchUrl = [[NSMutableString alloc] initWithString:@"/api/user_room"];
    [fetchUrl appendString:[NSMutableString stringWithFormat:@"?s_no=%d&e_no=%d",10*self.curPage-9,(10*self.curPage-9)+9]];
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET" path:fetchUrl parameters:nil];
    [request setValue:self.mobileSvc.client.currentUser.mobileServiceAuthenticationToken forHTTPHeaderField:@"X-ZUMO-AUTH"];
    [self.HUD show:TRUE];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self.HUD hide:TRUE];
        if([[[JSON objectForKey:@"code"] stringValue] isEqualToString:@"100"]){
            self.totalPage = ([[JSON objectForKey:@"create_room_cnt"] intValue]+[[JSON objectForKey:@"join_room_cnt"] intValue])/10;
            for(id roomDictionary in [JSON objectForKey:@"roomList"]){
                WRRoom *room = [[WRRoom alloc] initWithDictionary:roomDictionary];
                [self.rooms addObject:room];
            }
            [self.tableView reloadData];
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
    }];
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //if(self.curPage ==0 ){
        //return 1;
    //}
    if(self.curPage < self.totalPage){
        return self.rooms.count +1;
    }
    return self.rooms.count;
}

-(UITableViewCell *) roomCellForIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"room";
    WRMyRoomListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[WRMyRoomListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    WRRoom *room = [self.rooms objectAtIndex:indexPath.row
                    ];
    cell.roomTitle.text = room.roomTitle;
    // Configure the cell...
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.rooms.count){
        return [self roomCellForIndexPath:indexPath];
    }else{
        return [self loadingCell];
    }
}

-(UITableViewCell *)loadingCell{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellTag;
    
    return cell; 
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(cell.tag == kLoadingCellTag){
        self.curPage++;
        [self fetchRooms];
    }
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
    WRRoom *room = [self.rooms objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"WRRoomViewSegue" sender:room];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"WRRoomViewSegue"]) {
        WRRoomDetailTableViewController *controller = [segue destinationViewController];
        WRRoom *room = sender;
        controller.room = room;
        if(self.fromView != nil){
            controller.fromView = @"WRCategoryListViewController";
        }else{
            controller.fromView = @"WRMyRoomListViewController";
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WRRoom *room = [self.rooms objectAtIndex:indexPath.row];
        if([self.mobileSvc.client.currentUser.userId isEqualToString:room.roomManagerId]){
            NSMutableString * delUrl = [[NSMutableString alloc] initWithString:@"/api/room"];
            [delUrl appendString:[NSMutableString stringWithFormat:@"?room_no=%d",room.roomNo]];
            NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"DELETE" path:delUrl parameters:nil];
            [request setValue:self.mobileSvc.client.currentUser.mobileServiceAuthenticationToken forHTTPHeaderField:@"X-ZUMO-AUTH"];
            [self.HUD show:YES];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                [self.HUD hide:YES];
                if([[[JSON objectForKey:@"code"] stringValue] isEqualToString:@"100"]){
                    [self.mobileSvc makeAlertView:@"삭제성공" :self];
                    [self.rooms removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadData];
                }
            }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                // code for failed request goes here
            }];
            [operation start];
        }else{
            [self.mobileSvc makeAlertView:@"권한이 없습니다." :self];
        }
    }
}

@end
