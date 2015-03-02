//
//  FriendTableViewCell.h
//  FartWatch
//
//  Created by Jake Saferstein on 2/26/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendTableViewCell : UITableViewCell

@property (nonatomic) PFUser* user;
@property (nonatomic) NSString* userId;
@property (nonatomic) int secondsLeft;
@property (nonatomic) NSTimer* timer;
@property (nonatomic) UILabel* lbl;

-(void)startTimer;

@end
