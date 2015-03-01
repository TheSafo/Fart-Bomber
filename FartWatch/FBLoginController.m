//
//  FBLoginController.m
//  FartWatch
//
//  Created by Jake Saferstein on 2/27/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "FBLoginController.h"

@interface FBLoginController ()

@end

@implementation FBLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];

    
    if([PFFacebookUtils isLinkedWithUser: [PFUser  currentUser]] && [PFUser currentUser]) {
        
        UIActivityIndicatorView* test = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        test.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100);
        test.color = [UIColor blackColor];
        [self.view addSubview:test];
        
        [test startAnimating];
        
        UIImageView* fb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook7.png"]];
        fb.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 150, 100, 100);
//        fb.tintColor = [UIColor whiteColor];
        [self.view addSubview:fb];
        
        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error)
            {
                NSArray* friendObjects= [result objectForKey:@"data"];
                NSMutableArray* friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
                for (NSDictionary* friendObject in friendObjects) {
                    [friendIds addObject:[friendObject objectForKey:@"id"]];
                }
                
                // Construct a PFUser query that will find friends whose facebook ids
                // are contained in the current user's friend list.
                PFQuery *friendQuery = [PFUser query];
                [friendQuery whereKey:@"fbId" containedIn:friendIds];
                
                //PFUsers Array
                NSArray *friendUsers = [friendQuery findObjects];
                
                [((FriendsListViewController *)[self.navigationController viewControllers][1]) setFriends:friendUsers];

                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
    else
    {
    

    
    UIButton* login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    login.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50, 100, 100);
    
    login.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:login];
    
    [login addTarget:self action:@selector(loginPressed) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)loginPressed
{
    
    NSArray* permissions = @[ @"public_profile", @"user_friends", ];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
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
                        NSMutableArray* friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
                        for (NSDictionary* friendObject in friendObjects) {
                            [friendIds addObject:[friendObject objectForKey:@"id"]];
                        }
                        
                        // Construct a PFUser query that will find friends whose facebook ids
                        // are contained in the current user's friend list.
                        PFQuery *friendQuery = [PFUser query];
                        [friendQuery whereKey:@"fbId" containedIn:friendIds];
                        
                        //PFUsers Array
                        NSArray *friendUsers = [friendQuery findObjects];
                        
                        ((FriendsListViewController *)self.presentingViewController).friends = friendUsers;
                        
                        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                            NSLog(@"Going back");
                        }];
                    }
                }];
            }
        }];
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
