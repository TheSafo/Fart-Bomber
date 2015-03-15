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
#import "BlocksKit+UIKit.h"
#import <Pop/POP.h>
#import <UIAlertView+BlocksKit.h>
#import <RKCardView/RKCardView.h>
#import <LetterpressExplosion/UIView+Explode.h>

@interface BombingViewController ()

@property (nonatomic, strong) RKCardView* cardView;
@property (nonatomic, strong) UIVisualEffectView *blurredEffectView;
@property (nonatomic, strong) UIButton* confirmation;
@property (nonatomic, strong) UIBlurEffect* blurEffect;
@property (nonatomic, strong) UITextField* message;

@property (nonatomic, strong) WLVerticalSegmentedControl* testCtrl;


@property (nonatomic) ADInterstitialAd* theAd;

@end

@implementation BombingViewController


-(id)initWithStyle:(UITableViewStyle)style andRevengeList: (NSMutableArray *)arr1 andRecentList: (NSMutableArray *)arr2 andFriendsList: (NSMutableArray *)arr3
{
    if(self = [super init])
    {
        
        self.view = [[UIView alloc] initWithFrame:[[[[UIApplication sharedApplication] windows] firstObject] frame]];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain  target:self action:@selector(backPressed)];
        self.title = @"Send Farts";
        
        
        CGRect tblFrm = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        self.tableView = [[UITableView alloc] initWithFrame:tblFrm style:style];
        self.tableView.dataSource = self;
        
        self.tableView.delegate = self;
        
        [self.view addSubview:self.tableView];
        
        if(ADS_ON)
        {
            _theAd = [[ADInterstitialAd alloc] init];
            _theAd.delegate = self;
        }
        
        
        _revengeIds = arr1;
        _recentIds = arr2;
        _friendIds = arr3;
    }
    return self;
}

-(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd
{
    NSLog(@"Ad loaded");
}

-(void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
    NSLog(@"Ad unloaded");
}

-(void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    NSLog(@"Ad failed to load");
}

-(void)dismissKeyboard {
    [_message resignFirstResponder];
}

-(void)startFartAnimWithCell: (FriendTableViewCell *) cell andPath:(NSIndexPath *)indexPath
{
    
    PFUser* usr = cell.user;
    
    int h = self.tableView.frame.size.height - 54;
    int w = self.tableView.frame.size.width;
    
    _blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurredEffectView = [[UIVisualEffectView alloc] initWithEffect:_blurEffect];
    [_blurredEffectView setFrame:CGRectMake(0, 54, w, h)];
    
    int h2 = _blurredEffectView.frame.size.height;
    int w2 = _blurredEffectView.frame.size.width;
    
    _cardView = [[RKCardView alloc]initWithFrame:CGRectMake(w2/16.0, h2/16.0, w2*7.0/8.0, h2*7.0/8.0)];
    
    _cardView.coverImageView.image = [UIImage imageNamed:@"cushion3"];
    _cardView.profileImageView.image = cell.imageView.image;
    _cardView.titleLabel.text = usr[@"name"];
//    _cardView.backgroundColor = [UIColor colorWithRed:247 green:186 blue:186 alpha:1];
    
    _cardView.transform = CGAffineTransformMakeTranslation(w2, 0);
    
    
    /** STUFF IN THE CARDVIEW */
    int h3 = _cardView.frame.size.height;
    int w3 = _cardView.frame.size.width;
    
    UILabel* msgTitle = [[UILabel alloc]initWithFrame:CGRectMake(w3/8 + 5, h3*4/8, w3*3/4, 15)];
    msgTitle.textAlignment = NSTextAlignmentLeft;
    msgTitle.text = @"Message to Send";
    msgTitle.textColor = [UIColor lightGrayColor];
    
    _testCtrl = [[WLVerticalSegmentedControl alloc] initWithItems:@[@"Message", @"Button1", @"Button2"]];
    _testCtrl.frame = CGRectMake(w3/8, h3/2 + 20, w3*3/4, h3*3/8);
    _testCtrl.allowsMultiSelection = NO;
    ((WLSegment *)_testCtrl.segments[1]).backgroundColor = [UIColor redColor];
    ((WLSegment *)_testCtrl.segments[2]).backgroundColor = [UIColor redColor];
    ((WLSegment *)_testCtrl.segments[1]).tintColor = [UIColor blackColor];
    ((WLSegment *)_testCtrl.segments[2]).tintColor = [UIColor blackColor];

    //OLD!
    {
//    _message = [[UITextField alloc] initWithFrame:CGRectMake(w3/8, h3*4/8 + 20, w3*3/4, 40)];
//    [_message setEnabled:NO];
//    _message.layer.cornerRadius = 5;
//    _message.textAlignment = NSTextAlignmentCenter;
//    _message.borderStyle = UITextBorderStyleLine;
//    _message.layer.borderWidth = 5;
//    
//    
//    _confirmation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _confirmation.backgroundColor = [UIColor grayColor];
//    [_confirmation setTitle:@"SEND FART" forState:UIControlStateNormal];
//    _confirmation.titleLabel.textAlignment = NSTextAlignmentCenter;
//    _confirmation.titleLabel.textColor = [UIColor blackColor];
//    _confirmation.layer.cornerRadius = 10;
//    
//   
//    /** If custom isn't on */
//    if(!CUSTOM_MSG_ON)
//    {
//        UIButton* buyCustom = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        UIImageView* lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locked59.png"]];
//        
//        buyCustom.frame = CGRectMake(w3/8, h3*4/8 + 40 + 20 + 20, w3*3/4, h3/8);
//        buyCustom.backgroundColor = [UIColor grayColor];
//        [buyCustom setTitle:@"Unlock Custom Farts" forState:UIControlStateNormal];
//        buyCustom.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        buyCustom.contentEdgeInsets = UIEdgeInsetsMake(buyCustom.contentEdgeInsets.top, 10, buyCustom.contentEdgeInsets.bottom, buyCustom.contentEdgeInsets.top);
//        buyCustom.titleLabel.textColor = [UIColor blackColor];
//        buyCustom.layer.cornerRadius = 10;
//    
//        int h4 = buyCustom.frame.size.height;
//        int w4 = buyCustom.frame.size.width;
//        lock.frame = CGRectMake(w4 - h4 - 5, 5, h4 - 10, h4 - 10 );
//        
//        [_cardView addSubview:buyCustom];
//        [buyCustom addSubview:lock];
//        
//        _confirmation.frame = CGRectMake(w3/8, h3*4/8 + 40 + 20 + h3/8 + 20 + 20, w3*3/4, h3/8);
//    }
//    else
//    {
//        _confirmation.frame = CGRectMake(w3/8, h3*4/8 + 40 + 20 + 20, w3*3/4, h3*2/8);
//        [_message setEnabled:YES];
//    }
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [_blurredEffectView addGestureRecognizer:tap];
    
    _message.text = @"FART BOMB";
    /** END OF STUFF IN CARDVIEW */
    
    
    [self.view addSubview:_blurredEffectView];
    [_blurredEffectView addSubview:_cardView];
//    [_cardView addSubview:_confirmation];
//    [_cardView addSubview:_message];
//    [_cardView addSubview:msgTitle];
    [_cardView addSubview:_testCtrl];
    
    
    [UIView animateWithDuration:.75 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _cardView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) { }];

    
    [_testCtrl.segments[2] bk_addEventHandler:^(id sender) {
//        [_confirmation setEnabled:NO];
        _testCtrl.enabled = NO;
        
        /** Send the push */
        [self finalizePushWithCell:cell andPath:indexPath andMsg:_message.text];
        
        /** BOMB EVERYTHING */
        UIImageView* temp = [[UIImageView alloc] initWithFrame:CGRectMake(w, h/16, w/4, w/4)];
        temp.image = [UIImage imageNamed:@"bomber.png"];
        
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        anim.duration = 3;
        anim.toValue = @(-temp.frame.size.width);
        anim.beginTime = CACurrentMediaTime();
        
        
        
        UIImageView* temp2 = [[UIImageView alloc] initWithFrame:CGRectMake(w - 80, h/16 + w/8, w/8, w/8)];
        temp2.image = [UIImage imageNamed:@"beanBomb.png"];
        
        int delay = .8;
        
        POPBasicAnimation *anim2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
        anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        anim2.duration = 3;
        anim2.toValue = [NSValue valueWithCGPoint:CGPointMake(w/4, h*3/4)];
        anim2.beginTime = CACurrentMediaTime() + delay;
#warning play sound???

        
        
        [self.view addSubview:temp];
        
        [self.view performSelector:@selector(addSubview:) withObject:temp2 afterDelay:delay];
//        [self.view addSubview:temp2];
        
        
        [temp.layer pop_addAnimation:anim forKey:@"fly"];
        [temp2.layer pop_addAnimation:anim2 forKey:@"bomb"];
        
        anim2.completionBlock =  ^(POPAnimation* completedAnim, BOOL completed) {
            [temp2 lp_explodeWithCompletion:^(BOOL completed) {
            }];
            
            /** Animate the views to dissapear and shit */
            [_cardView removeFromSuperview];
            [_blurredEffectView lp_explodeWithCompletion:^(BOOL completed) {
                
                
                if (ADS_ON && _theAd.loaded)
                {
                    [_theAd performSelector:@selector(presentFromViewController:) withObject:self afterDelay:.5];
                }
            }];
            
        };
    } forControlEvents:UIControlEventTouchUpInside];
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
    [self startFartAnimWithCell:tappedCell andPath:indexPath];
}

-(void)finalizePushWithCell: (FriendTableViewCell*) tappedCell andPath:(NSIndexPath *)indexPath andMsg: (NSString *)msg
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
        [self sendPushtoUser:toSend withMsg:msg];
        
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



-(void)sendPushtoUser: (PFUser *)toSend withMsg: (NSString *) msg
{
    PFQuery *qry = [PFInstallation query];
    [qry whereKey:@"user" equalTo:toSend];
    
    NSString* realMsg = [NSString stringWithFormat:@"%@ from %@", msg, [PFUser currentUser][@"name"]];
    
    int x = arc4random_uniform(7) + 1;
    NSString* sound = [NSString stringWithFormat:@"fart%i.caf", x]; ///Randomizes sound!!!
    
    NSDictionary *data = @{ @"alert" : realMsg,
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
