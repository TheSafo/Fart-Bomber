//
//  BombingViewController.h
//  FartWatch
//
//  Created by Jake Saferstein on 2/28/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface IntermediateViewController : UIViewController

/**
THIS CONTROLLER DOES...
 
 1. Allow users to connect to FB with a button
 2. Log the user in + grab the users friends, recents, revenges ASYNCHRONOUSLY
 3. Sends + pushes that info to the TableViewController
 
*/


@property (nonatomic) NSMutableArray* revengeIds;
@property (nonatomic) NSMutableArray* friendIds;
@property (nonatomic) NSMutableArray* recentIds;


@end
