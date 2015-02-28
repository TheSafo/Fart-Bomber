//
//  FriendsListViewController.h
//  
//
//  Created by Jake Saferstein on 2/26/15.
//
//

#import <UIKit/UIKit.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Parse/Parse.h>
#import "FriendTableViewCell.h"

@interface FriendsListViewController : UITableViewController

@property(nonatomic) NSMutableArray* revenge;
@property(nonatomic) NSMutableArray* recent;
@property(nonatomic) NSArray* friends;

@property (nonatomic) BOOL shouldntUseThis;


-(void)setFriends:(NSArray *)friends;


@end
