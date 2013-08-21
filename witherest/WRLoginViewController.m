//
//  WRLoginViewController.m
//  witherest
//
//  Created by 이종현 on 13. 7. 5..
//  Copyright (c) 2013년 witherest. All rights reserved.
//
#import "AFJSONRequestOperation.h"
#import "WRLoginViewController.h"
#import "WRHttpClientInfo.h"
#import "AFHTTPClient.h"
#import "WRHttpClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "WRAppDelegate.h"
#import "KeychainItemWrapper.h"
#import <FacebookSDK/FacebookSDK.h>

@interface WRLoginViewController () <FBLoginViewDelegate>
-(void)getFacebookProfile:(NSString *)accToken;
@end

@implementation WRLoginViewController

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
    self.appDelegate = [[UIApplication sharedApplication] delegate];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) submit:(id)sender
{
    [self loginWithProvider:@"facebook"];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    NSLog(@"loginViewFetchedUserInfo");
}

-(void)loginWithProvider:(NSString *)provider
{
    self.mobileSvc.authProvider = provider;
    MSLoginController *controller =
    [self.mobileSvc.client
     loginViewControllerWithProvider:provider
     completion:^(MSUser *user, NSError *error) {
         if (error) {
             NSLog(@"Authentication Error: %@", error);
             // Note that error.code == -1503 indicates
             // that the user cancelled the dialog
         } else {
             [self.mobileSvc saveAuthInfo];
             UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"WRMainViewStoryboard" bundle:nil];
             UIViewController *viewController = [storyBoard instantiateInitialViewController];
             [self.appDelegate changeRootViewController:viewController];
         }
         
         NSString *url = [[NSString alloc]initWithUTF8String:WR_HTTP_HOST];
         WRHttpClient *client = [WRHttpClient sharedClient:url];
   
         NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"/api/user" parameters:nil];
         [request setValue:self.mobileSvc.client.currentUser.mobileServiceAuthenticationToken forHTTPHeaderField:@"X-ZUMO-AUTH"];
         AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
             // code for successful return goes here
             if([[[JSON objectForKey:@"code"] stringValue] isEqualToString:@"100"]){
                 NSDictionary *dic = [JSON objectForKey:@"user"];
                 NSString *token = [dic objectForKey:@"fb_token"];
             }
             
             //[KeychainItemWrapper createKeychainValue:self.client.currentUser.userId forIdentifier:@"userid"];
             [self.mobileSvc saveAuthInfo];
             // do something with return data
         }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
             // code for failed request goes here
             // do something on failure
         }];
         [operation start];
         [self dismissViewControllerAnimated:YES completion:nil];
     }];	// Do any additional setup after loading the view.
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)getFacebookProfile:(NSString *)accToken{
    
}

@end
