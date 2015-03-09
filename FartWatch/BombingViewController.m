//
//  BombingViewController.m
//  FartWatch
//
//  Created by Jake Saferstein on 2/28/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "BombingViewController.h"
#import "FriendTableViewCell.h"
#import <BlocksKit/BlocksKit.h>
#import <Pop/POP.h>
#import <UIAlertView+BlocksKit.h>
#import <RKCardView/RKCardView.h>

@interface BombingViewController ()

@end

@implementation BombingViewController


-(id)initWithStyle:(UITableViewStyle)style andRevengeList: (NSMutableArray *)arr1 andRecentList: (NSMutableArray *)arr2 andFriendsList: (NSMutableArray *)arr3
{
    if(self = [super initWithStyle:style])
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain  target:self action:@selector(backPressed)];
        self.title = @"Send Farts";
        
        _revengeIds = arr1;
        _recentIds = arr2;
        _friendIds = arr3;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //Debugging only
//    [PFUser currentUser][@"revenge"] = [NSMutableArray array];
//    [[PFUser currentUser] saveInBackground];
}

-(void)startFartAnimWithUser: (PFUser *) usr andImg: (UIImage *)img
{
    int h = self.view.frame.size.height;
    int w = self.view.frame.size.width;
    
//    UIView* testVw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
//    testVw.backgroundColor = [UIColor blueColor];
//    testVw.layer.shadowOffset = CGSizeMake(10, 10);
//    testVw.layer.shadowOpacity = .5;
//    testVw.layer.shadowRadius = 5;
//    
//    testVw.transform = CGAffineTransformMakeTranslation(w, 0);
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [bluredEffectView setFrame:CGRectMake(0, 0, w, h)];
    
    RKCardView* cardView= [[RKCardView alloc]initWithFrame:CGRectMake(w/8.0, h/8.0, w*3.0/4.0, h*3.0/4.0)];
    
    cardView.coverImageView.image = [UIImage imageNamed:@"cushion3"];
    cardView.profileImageView.image = img;
    cardView.titleLabel.text = usr[@"name"];
    //[cardView addBlur]; // comment this out if you don't want blur
    [cardView addShadow]; // comment this out if you don't want a shadow
    
    cardView.transform = CGAffineTransformMakeTranslation(w, 0);
    
    
    UIView* test = [[UIView alloc] initWithFrame:CGRectMake(w/8.0, h/8.0, w*3.0/4.0, h*3.0/4.0)];
    test.backgroundColor = [UIColor greenColor];

    
    [self.tableView addSubview:bluredEffectView];
    [bluredEffectView addSubview:test];
    [bluredEffectView addSubview:cardView];



    
    [UIView animateWithDuration:.75 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        cardView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    

//    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPopLayer];
//    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    anim.duration = 1;
//    anim.toValue = @(0);
//    anim.beginTime = CACurrentMediaTime();
//    
//    [testVw pop_addAnimation:anim forKey:@"frameX"];
//
//    anim.completionBlock =  ^(POPAnimation* completedAnim, BOOL completed) {
//        
//    };

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* arr;
    switch (indexPath.section) {
        case 0:
            arr = _revengeIds;
            break;
        case 1:
            arr = _recentIds;
            break;
        case 2:
            arr = _friendIds;
            break;
    }
    
    FriendTableViewCell* tappedCell = (FriendTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    /** Fancy ass animation for confirmation */
    [self startFartAnimWithUser:tappedCell.user andImg: tappedCell.imageView.image];

    
    /** Update recentIds on tableview/user */
    NSString* sendStr = tappedCell.userId;
    NSString* userStr = [PFUser currentUser].objectId;
    
    if ([_recentIds containsObject:sendStr]) {
        [_recentIds removeObject:sendStr];
    }
    if (_recentIds.count == 5) {
        [_recentIds removeLastObject];
    }
    [_recentIds insertObject:sendStr atIndex:0];
    

    
    [PFUser currentUser][@"recent"] = _recentIds;
    
    NSString* toSendId = arr[indexPath.row];
    
    
    /** Remove a user from revenge once revenge has been served coldly*/
    if([_revengeIds containsObject:toSendId])
    {
        [self.revengeIds removeObject:toSendId];
        [[PFUser currentUser][@"revenge"] removeObject:toSendId];
        [[PFUser currentUser] saveInBackground];
    }
    
    [self.tableView reloadData];
    [[PFUser currentUser] saveInBackground];

    
    PFQuery* temp = [PFUser query];
    
    [temp getObjectInBackgroundWithId:toSendId block:^(PFObject *object, NSError *error) {
        /** Cast result to user*/
        PFUser* toSend = (PFUser *)object;
        
        /** Send push */
        [self sendPushtoUser:toSend];
        
        /** Update on parse other user's revenge list */
        NSMutableArray* sendArr = [toSend objectForKey:@"revenge"];
            
        if([sendArr containsObject:userStr])
        {
            [sendArr removeObject:userStr];
        }
        if (sendArr.count == 5) {
            [sendArr removeLastObject];
        }
        [sendArr insertObject:userStr atIndex:0];
        
        [PFCloud callFunctionInBackground:@"editUser" withParameters:@{@"userId": toSendId, @"newRev":sendArr} block:^(id object, NSError *error) {
            if(error) { NSLog(@"Cloud error: %@", error); }
        }];
        
    }];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)sendPushtoUser: (PFUser *)toSend
{
    PFQuery *qry = [PFInstallation query];
    [qry whereKey:@"user" equalTo:toSend];
    
    NSString* msg = [NSString stringWithFormat:@"FART BOMBED by %@", [PFUser currentUser][@"name"]];
    
    int x = arc4random_uniform(7) + 1;
    NSString* sound = [NSString stringWithFormat:@"fart%i.caf", x]; ///Randomizes sound!!!
    
    NSDictionary *data = @{ @"alert" : msg,
                            @"sound" : sound,};
    
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:qry];
    [push setData:data];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error)
        {
            NSLog(@"Push Error: %@", error);
        }
    }];
}

-(void)backPressed
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend"];
    
    if(!cell)
    {
        cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"friend"];
    }
    
    NSMutableArray* arr;
    switch (indexPath.section) {
        case 0:
            arr = _revengeIds;
            break;
        case 1:
            arr = _recentIds;
            break;
        case 2:
            arr = _friendIds;
            break;
    }
    
//    NSLog(@"%li , %li", (long)indexPath.section, (long)indexPath.row);
    
    [((FriendTableViewCell *)cell) setUserId:arr[indexPath.row]];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _revengeIds.count;
            break;
        case 1:
            return _recentIds.count;
            break;
        case 2:
            return _friendIds.count;
            break;
        default:
            return -1;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Revenge";
            break;
        case 1:
            sectionName = @"Recent";
            break;
        case 2:
            sectionName = @"Friends";
            break;
    }
    return sectionName;
}
@end
