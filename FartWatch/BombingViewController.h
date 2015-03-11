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

@interface BombingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic) UITableView* tableView;
@property (nonatomic) NSMutableArray* revengeIds;
@property (nonatomic) NSMutableArray* friendIds;
@property (nonatomic) NSMutableArray* recentIds;


-(id)initWithStyle:(UITableViewStyle)style andRevengeList: (NSMutableArray *)arr1 andRecentList: (NSMutableArray *)arr2 andFriendsList: (NSMutableArray *)arr3;



@end
