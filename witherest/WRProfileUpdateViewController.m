//
//  WRProfileUpdateViewController.m
//  witherest
//
//  Created by 이종현 on 13. 8. 1..
//  Copyright (c) 2013년 witherest. All rights reserved.
//

#import "WRProfileUpdateViewController.h"
#import "WRCategoryListViewController.h"
#import "WRHttpClientInfo.h"
#import "WRHttpClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFJSONRequestOperation.h"
#import "WRUser.h"
#import "WRCategory.h"


@interface WRProfileUpdateViewController ()
-(void)fetchUserInfo;
@property(nonatomic,strong) NSString *hostUrl;
@property(nonatomic,strong) WRHttpClient *httpClient;

@end

@implementation WRProfileUpdateViewController
@synthesize userCategory = _userCategory;
@synthesize image = _image;

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
    [self.navigationController.view addSubview:self.HUD];
    
    self.hostUrl = [[NSString alloc]initWithUTF8String:WR_HTTP_HOST];
    self.httpClient = [WRHttpClient sharedClient:self.hostUrl];

    NSString *imageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%d/picture?type=large",[[self.mobileSvc.client.currentUser.userId componentsSeparatedByString:@":"] objectAtIndex:1]];
    [WRHttpClient downloadingServerImageFromUrl:self.image AndUrl:imageUrl];
    
    [self.userName addTarget:self action:@selector(clearTextForm:) forControlEvents:UIControlEventEditingDidBegin];
    [self.userEmail addTarget:self action:@selector(clearTextForm:) forControlEvents:UIControlEventEditingDidBegin];
    [self.userProfile addTarget:self action:@selector(clearTextForm:) forControlEvents:UIControlEventEditingDidBegin];
    [self.userTech addTarget:self action:@selector(clearTextForm:) forControlEvents:UIControlEventEditingDidBegin];
    
    [self fetchUserInfo];
    
    [self.navigationController.view addSubview:self.HUD];
    //[self.image setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"profile.jpg"]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) clearTextForm:(id)sender{
    NSLog(@"clear text form");
    [(UITextField *)sender setText:@""];
}

-(void)fetchUserInfo{
    self.mobileSvc = [WRMobileService getInstance];
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET" path:@"/api/user" parameters:nil];
    [request setValue:self.mobileSvc.client.currentUser.mobileServiceAuthenticationToken forHTTPHeaderField:@"X-ZUMO-AUTH"];
    [self.HUD show:TRUE];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // code for successful return goes here
        // do something with return data
        [self.HUD hide:TRUE];
        if([[[JSON objectForKey:@"code"]stringValue] isEqual: @"100"]){
            WRUser *user = [[WRUser alloc] initWithDictionary:[JSON objectForKey:@"user"]];
            if(user.userName != nil){
                [self.userName setText:user.userName];
            }
            if(user.userGroup != nil){
                [self.userTech setText:user.userGroup];
            }
            if(user.userProfile != nil){
                [self.userProfile setText:user.userProfile];
            }
            if([JSON objectForKey:@"user_category"] != nil){
                user.userCategory = [JSON objectForKey:@"user_category"];
            }
            if(user.userCategory != nil){
                NSMutableString *selCat= [[NSMutableString alloc]init];
                for(int i=0;i<[user.userCategory count]; i++){
                    if(i == [user.userCategory count]-1){
                        [selCat appendFormat:@"%@",[[user.userCategory objectAtIndex:i]objectForKey:@"category_name"]];
                    }else{
                        [selCat appendFormat:@"%@ | ",[[user.userCategory objectAtIndex:i]objectForKey:@"category_name"]];
                    }
                }
                [self.userCatLabel setText:selCat];
            }
            [self.userName setText:user.userName];
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        // do something on failure
    }];
    [operation start];
}

-(IBAction) modify:(id)sender{
    if([self.userName.text isEqualToString:@"카테고리"]){
        [self.mobileSvc makeAlertView:@"카테고리를 입력하세요." :self];
        return;
    }else if([self.userName.text isEqualToString:@"이름"]){
        [self.mobileSvc makeAlertView:@"이름을 입력하세요." :self];
        return;
    }else if([self.userName.text isEqualToString:@"이메일"]){
        [self.mobileSvc makeAlertView:@"이메일을 입력하세요." :self];
        return;
    }else if([self.userName.text isEqualToString:@"프로필"]){
        [self.mobileSvc makeAlertView:@"프로필을 입력하세요." :self];
        return;
    }else if([self.userTech.text isEqualToString:@"보유기술"]){
        [self.mobileSvc makeAlertView:@"보유기술을 입력하세요." :self];
        return;
    }
    NSMutableDictionary *userCategory = [[NSMutableDictionary alloc] init];
    for(int i=1; i<=[self.userCategory count]; i++){
        WRCategory *category = [self.userCategory objectAtIndex:i-1];
        [userCategory setObject:[category.categoryNo stringValue] forKey:[NSString stringWithFormat:@"category_no_%d",i]];
    }
    NSString *imageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%d/picture?type=large",[[self.mobileSvc.client.currentUser.userId componentsSeparatedByString:@":"] objectAtIndex:1]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [self.userName text], @"user_name",
                            [self.userEmail text], @"user_email",
                            [self.userProfile text], @"user_profile",
                            [self.userTech text], @"user_group",
                            imageUrl, @"user_img"
                            ,nil];
    for (NSString* key in userCategory) {
        NSString *value = [userCategory objectForKey:key];
        [params setObject:value forKey:key];
    }
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"PUT" path:@"/api/user" parameters:params];
    [request setValue:self.mobileSvc.client.currentUser.mobileServiceAuthenticationToken forHTTPHeaderField:@"X-ZUMO-AUTH"];
    [self.HUD show:TRUE];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self.HUD hide:TRUE];
        if([[[JSON objectForKey:@"code"]stringValue] isEqual: @"100"]){
            [[self navigationController] popViewControllerAnimated:YES];
        }else{
            [self.mobileSvc makeAlertView:@"업데이트 실패" :self];
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // code for failed request goes here
        // do something on failure
    }];
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    //[self.userCatLabel setText:@"카테고리"];
    NSMutableString *selCat= [[NSMutableString alloc]init];
    if([self.userCategory count] != 0){
        for(int i=0;i<[self.userCategory count]; i++){
            WRCategory *category = [self.userCategory objectAtIndex:i];
            if(i == [self.userCategory count]-1){
                [selCat appendFormat:@"%@",category.categoryName];
            }else{
                [selCat appendFormat:@"%@ | ",category.categoryName];
            }
        }
        [self.userCatLabel setText:selCat];
    }
}
#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/
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
    [self performSegueWithIdentifier:@"categorySelectSegue" sender:self ];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"categorySelectSegue"]){
        WRCategoryListViewController *controller = [segue destinationViewController];
        controller.fromView = @"WRProfileUpdateViewController";
        controller.delegate = self;
    }
}
@end
