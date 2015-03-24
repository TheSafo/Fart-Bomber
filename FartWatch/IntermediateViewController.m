//
//  BombingViewController.m
//  FartWatch
//
//  Created by Jake Saferstein on 2/28/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "IntermediateViewController.h"
#import "BombingViewController.h"

@interface IntermediateViewController ()

@end

@implementation IntermediateViewController

@synthesize recentIds,revengeIds,friendIds;

-(id)init
{
    if (self = [super init]) {
        self.revengeIds = [NSMutableArray array];
        self.recentIds = [NSMutableArray array];
        self.friendIds = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain  target:self action:@selector(backPressed)];
    
    if([PFFacebookUtils isLinkedWithUser: [PFUser  currentUser]] && [PFUser currentUser]) {
        self.title = @"Connecting to Facebook";
        
        
 
        
        /** Start an Activity Indicator while loading friends list */
        UIActivityIndicatorView* test = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        test.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100);
        test.color = [UIColor blackColor];
        [self.view addSubview:test];
        [test startAnimating];

        UIImageView* fb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook7.png"]];
        fb.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 150, 100, 100);
        [self.view addSubview:fb];
        
        
        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error)
            {
                NSArray* friendObjects= [result objectForKey:@"data"];
                NSMutableArray* tempFriendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
                for (NSDictionary* friendObject in friendObjects) {
                    [tempFriendIds addObject:[friendObject objectForKey:@"id"]];
                }
                
                // Construct a PFUser query that will find friends whose facebook ids
                // are contained in the current user's friend list.
                PFQuery *friendQuery = [PFUser query];
                [friendQuery whereKey:@"fbId" containedIn:tempFriendIds];
                
                [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    for (PFUser* temp in objects) {
                        [self.friendIds addObject: temp.objectId];
                    }
                    NSLog(@"Done adding to friends list");
                    
                    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        self.revengeIds =  [[PFUser currentUser] objectForKey:@"revenge"]; //= @[@"9oPcwNoSjI"]; //= @[@"xFlcvadOFv"];
                        self.recentIds = [PFUser currentUser][@"recent"];
                        
                            BombingViewController* nextCtrlr = [[BombingViewController alloc] initWithStyle:UITableViewStylePlain andRevengeList:self.revengeIds andRecentList:self.recentIds andFriendsList:self.friendIds];
                            [self.navigationController pushViewController:nextCtrlr animated:YES];

                    }];
                }];
            }
        }];
    }
    
    else
    {
        self.title = @"Login with Facebook";
        /** Show Login button */
        
        UIImageView* fb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook7.png"]];
        fb.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 150, 100, 100);
        [self.view addSubview:fb];
        
        
        UIButton* login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        login.frame = CGRectMake(self.view.frame.size.width/4, fb.frame.origin.y + fb.frame.size.height + 20, self.view.frame.size.width/2, 50);
//        login.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 50);
        login.backgroundColor = [UIColor whiteColor];
        login.layer.cornerRadius = 10;
        [login setTitle:@"Connect to Facebook" forState:UIControlStateNormal];
        
        [self.view addSubview:login];
        [login addTarget:self action:@selector(loginPressed) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)backPressed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/** Login to facebook */
-(void)loginPressed
{
    NSArray* permissions = @[ @"public_profile", @"user_friends", ];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            
            self.revengeIds = user[@"revenge"] = [NSMutableArray array];
            self.recentIds = user[@"recent"] = [NSMutableArray array];
        } else {
            NSLog(@"User logged in through Facebook!");
            
            self.revengeIds = user[@"revenge"];
            self.recentIds = user[@"recent"];
        }
        
        PFInstallation* instll = [PFInstallation currentInstallation];
        instll[@"user"] = [PFUser currentUser];
        [instll saveInBackground];
        
        
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSLog(@"%@", result);
                user[@"fbId"] = result[@"id"];
                user[@"firstname"] = result[@"first_name"];
                user[@"lastname"] = result[@"last_name"];
                user[@"name"] = result[@"name"];
                user[@"gender"] = result[@"gender"];
                [user saveInBackground];
                
                [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if(!error)
                    {
                        NSArray* friendObjects= [result objectForKey:@"data"];
                        NSMutableArray* tempFriendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
                        for (NSDictionary* friendObject in friendObjects) {
                            [tempFriendIds addObject:[friendObject objectForKey:@"id"]];
                        }
                        
                        // Construct a PFUser query that will find friends whose facebook ids
                        // are contained in the current user's friend list.
                        PFQuery *friendQuery = [PFUser query];
                        [friendQuery whereKey:@"fbId" containedIn:tempFriendIds];
                        
                        [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            for (PFUser* temp in objects) {
                                [self.friendIds addObject: temp.objectId];
                            }
                            NSLog(@"Done adding to friends list");
                            
                            BombingViewController* nextCtrlr = [[BombingViewController alloc] initWithStyle:UITableViewStylePlain andRevengeList:self.revengeIds andRecentList:self.recentIds andFriendsList:self.friendIds];
                            [self.navigationController pushViewController:nextCtrlr animated:YES];
                        }];
                    }
                }];
            }
        }];
    }];
}


@end
