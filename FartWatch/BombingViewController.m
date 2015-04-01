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
#import "UIView+Explode.h"

@interface BombingViewController ()


//@property (nonatomic, strong) WLVerticalSegmentedControl* testCtrl;


@property (nonatomic) ADInterstitialAd* theAd;

@property (nonatomic, strong) RKCardView* cardView;
@property (nonatomic, strong) UIVisualEffectView *blurredEffectView;
@property (nonatomic, strong) UIButton* confirmation;
@property (nonatomic, strong) UIBlurEffect* blurEffect;
@property (nonatomic, strong) UITextField* message;

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
        
        
        
        NSString* fart1 = [[NSBundle mainBundle] pathForResource:@"fart1" ofType:@"caf"];
        NSURL* fart1URL = [NSURL fileURLWithPath:fart1];
        _plyr1 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart1URL error:nil];
        
        NSString* fart2 = [[NSBundle mainBundle] pathForResource:@"fart2" ofType:@"caf"];
        NSURL* fart2URL = [NSURL fileURLWithPath:fart2];
        _plyr2 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart2URL error:nil];
        
        NSString* fart3 = [[NSBundle mainBundle] pathForResource:@"fart3" ofType:@"caf"];
        NSURL* fart3URL = [NSURL fileURLWithPath:fart3];
        _plyr3 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart3URL error:nil];
        
        NSString* fart4 = [[NSBundle mainBundle] pathForResource:@"fart4" ofType:@"caf"];
        NSURL* fart4URL = [NSURL fileURLWithPath:fart4];
        _plyr4 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart4URL error:nil];
        
        NSString* fart5 = [[NSBundle mainBundle] pathForResource:@"fart5" ofType:@"caf"];
        NSURL* fart5URL = [NSURL fileURLWithPath:fart5];
        _plyr5 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart5URL error:nil];
        
        NSString* fart6 = [[NSBundle mainBundle] pathForResource:@"fart6" ofType:@"caf"];
        NSURL* fart6URL = [NSURL fileURLWithPath:fart6];
        _plyr6 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart6URL error:nil];
        
        NSString* fart7 = [[NSBundle mainBundle] pathForResource:@"fart7" ofType:@"caf"];
        NSURL* fart7URL = [NSURL fileURLWithPath:fart7];
        _plyr7 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart7URL error:nil];
        
        
        NSString* airstrike = [[NSBundle mainBundle] pathForResource:@"airstrike" ofType:@"mp3"];
        NSURL* airstrikeURL = [NSURL fileURLWithPath:airstrike];
        _plyrAirStrike = [[AVAudioPlayer alloc] initWithContentsOfURL:airstrikeURL error:nil];

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
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    PFUser* usr = cell.user;
    
    int h = self.tableView.frame.size.height - 54;
    int w = self.tableView.frame.size.width;
    
    _blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurredEffectView = [[UIVisualEffectView alloc] initWithEffect:_blurEffect];
    [_blurredEffectView setFrame:CGRectMake(0, 54, w, h)];
    
    int h2 = _blurredEffectView.frame.size.height;
    int w2 = _blurredEffectView.frame.size.width;
    
    _cardView = [[RKCardView alloc]initWithFrame:CGRectMake(w2/16.0, h2/16.0, w2*7.0/8.0, h2*7.0/8.0)];
    
    _cardView.coverImageView.image = [UIImage imageNamed:@"cushion2"];
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
    

    
    
    if (!CUSTOM_MSG_ON) {
        _testCtrl = [[WLVerticalSegmentedControl alloc] initWithItems:@[@"", @"Enable Custom Messages", @"Send Fart"]];
        _testCtrl.frame = CGRectMake(w3/8, h3/2 + 20, w3*3/4, h3*3/8);
        _testCtrl.allowsMultiSelection = NO;
        
        [((WLSegment *)_testCtrl.segments[0]) setEnabled:NO];
        
        ((WLSegment *)_testCtrl.segments[0]).tintColor = [UIColor blackColor];
        ((WLSegment *)_testCtrl.segments[1]).tintColor = [UIColor blackColor];
        ((WLSegment *)_testCtrl.segments[2]).tintColor = [UIColor blackColor];
        
        ((WLSegment *)_testCtrl.segments[1]).backgroundColor = [UIColor colorWithRed:200 green:50 blue:50 alpha:.5];
        ((WLSegment *)_testCtrl.segments[2]).backgroundColor = [UIColor colorWithRed:200 green:50 blue:50 alpha:.5];
        
//        ((WLSegment *)_testCtrl.segments[1]).backgroundColor = [UIColor redColor];
//        ((WLSegment *)_testCtrl.segments[2]).backgroundColor = [UIColor redColor];
        
        ((WLSegment *)_testCtrl.segments[1]).titleLabel.textColor = [UIColor blackColor];
        ((WLSegment *)_testCtrl.segments[2]).titleLabel.textColor = [UIColor blackColor];
        
//        int segW = ((WLSegment *)_testCtrl.segments[0]).frame.size.width;
//        int segH = ((WLSegment *)_testCtrl.segments[0]).frame.size.height;
        
        
        [((WLSegment *)_testCtrl.segments[1]) bk_addEventHandler:^(id sender) {
            [[StoreManager sharedInstance] purchaseCustom];
//            ((WLSegment *)_testCtrl.segments[1]).isSelected = NO;
        } forControlEvents:UIControlEventTouchUpInside];

        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(w3/8, h3/2 + 20, w3*3/4, h3*3/24)];
        lbl.text = @"Message: \n FART BOMBED";
        lbl.numberOfLines = 2;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.layer.zPosition = 1;
        
        [_cardView addSubview:lbl];
    }
    else
    {
        _testCtrl = [[WLVerticalSegmentedControl alloc] initWithItems:@[@"", @"Send Fart"]];
        _testCtrl.frame = CGRectMake(w3/8, h3/2 + 20, w3*3/4, h3*3/8);
        _testCtrl.allowsMultiSelection = NO;
        
        [((WLSegment *)_testCtrl.segments[0]) setEnabled:NO];
        
        ((WLSegment *)_testCtrl.segments[0]).tintColor = [UIColor blackColor];
        ((WLSegment *)_testCtrl.segments[1]).tintColor = [UIColor blackColor];
        
        ((WLSegment *)_testCtrl.segments[1]).backgroundColor = [UIColor colorWithRed:200 green:50 blue:50 alpha:.5];
        
        
//        ((WLSegment *)_testCtrl.segments[1]).backgroundColor = [UIColor redColor];
//        ((WLSegment *)_testCtrl.segments[1]).titleLabel.textColor = [UIColor blackColor];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(w3/8, h3/2 + 20, w3*3/4, h3*3/48)];
        lbl.text = @"Message:";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.layer.zPosition = 1;
        
        _message = [[UITextField alloc] initWithFrame:CGRectMake(w3/8, h3/2 + 20 + h3*3/48, w3*3/4, h3*3/48)];
        _message.placeholder = @"FART BOMBED";
        _message.textAlignment = NSTextAlignmentCenter;
        _message.autocorrectionType = UITextAutocorrectionTypeNo;
//        _message.layer.zPosition = 2;
        
        [_message setEnabled:YES];

        
        [_cardView addSubview:lbl];
    }
    
    
    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(w3/8, h3/2 + 20 + h3*3/8 + 5, 50, h3 - (h3/2 + 20 + h3*3/8) - 10);
//    cancelBtn.backgroundColor = [UIColor greenColor];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cardView addSubview:cancelBtn];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [_blurredEffectView addGestureRecognizer:tap];
    
//    _message.text = @"FART BOMB";
    /** END OF STUFF IN CARDVIEW */
    
    
    [self.view addSubview:_blurredEffectView];
    [_blurredEffectView addSubview:_cardView];
    [_cardView addSubview:_testCtrl];
    if (CUSTOM_MSG_ON) {
        [_cardView addSubview:_message];
    }
    
    
    [UIView animateWithDuration:.75 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _cardView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) { }];

    
    int theInt;
    if (CUSTOM_MSG_ON) {
        theInt = 1;
    }
    else
    {
        theInt = 2;
    }
    
    [_testCtrl.segments[theInt] bk_addEventHandler:^(id sender) {
//        [_confirmation setEnabled:NO];
        _testCtrl.enabled = NO;
        
        /** Send the push */
        
        NSString* msgToSend;
        if(CUSTOM_MSG_ON)
        {
            if(_message.text.length == 0)
            {
                msgToSend = _message.placeholder;
            }
            msgToSend = _message.text;
        }
        else
        {
            msgToSend=@"FART BOMBED";
        }
        
        [self finalizePushWithCell:cell andPath:indexPath andMsg:msgToSend];
        
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
        
        [temp2 setHidden:YES];
        
        int delay = .8;
        
        POPBasicAnimation *anim2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
        anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        anim2.duration = 3;
        anim2.toValue = [NSValue valueWithCGPoint:CGPointMake(w/4, h*3/4)];
        anim2.beginTime = CACurrentMediaTime() + delay;

        
        [self.view addSubview:temp];
        [self.view addSubview:temp2];
        
        [temp2 performSelector:@selector(setHidden:) withObject:nil afterDelay:delay];
        
//        [self.view performSelector:@selector(addSubview:) withObject:temp2 afterDelay:delay];
        
        
        [temp.layer pop_addAnimation:anim forKey:@"fly"];
        [temp2.layer pop_addAnimation:anim2 forKey:@"bomb"];
        [_plyrAirStrike play];
        
        
        anim2.completionBlock =  ^(POPAnimation* completedAnim, BOOL completed) {
            [self fartNoise];
            [temp2 lp_explodeWithCompletion:^(BOOL completed) {}];
            
            /** Animate the views to dissapear and shit */
            [_blurredEffectView lp_explodeWithCompletion:^(BOOL completed) {
                [temp removeFromSuperview];
                
                if (ADS_ON && _theAd.loaded)
                {
                    
                    [_theAd performSelector:@selector(presentFromViewController:) withObject:self afterDelay:.5];
                }
            }];
            
        };
    } forControlEvents:UIControlEventTouchUpInside];
}

-(void)cancelPressed: (UIButton *)btn
{
    [_blurredEffectView lp_explodeWithCompletion:^(BOOL completed) {
    }];
}

-(void)fartNoise
{
    AVAudioPlayer* temp;
    
    int x = arc4random_uniform(7) + 1;
    
    switch (x) {
        case 1:
            temp = _plyr1;
            break;
        case 2:
            temp = _plyr2;
            break;
        case 3:
            temp = _plyr3;
            break;
        case 4:
            temp = _plyr4;
            break;
        case 5:
            temp = _plyr5;
            break;
        case 6:
            temp = _plyr6;
            break;
        case 7:
            temp = _plyr7;
            break;
    }
    
    [temp play];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray* arr;
//    switch (indexPath.section) {
//        case 0:
//            arr = _revengeIds;
//            break;
//        case 1:
//            arr = _recentIds;
//            break;
//        case 2:
//            arr = _friendIds;
//            break;
//    }
    
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
}



-(void)sendPushtoUser: (PFUser *)toSend withMsg: (NSString *) msg
{
    PFQuery *qry = [PFInstallation query];
    [qry whereKey:@"user" equalTo:toSend];
    
    NSString* realMsg = [NSString stringWithFormat:@"%@ from %@", msg, [PFUser currentUser][@"name"]];
    
    int x = arc4random_uniform(7) + 1;
    NSString* sound = [NSString stringWithFormat:@"fart%i.caf", x]; ///Randomizes sound!!!
    
    NSDictionary *data = @{ @"alert" : realMsg,
                            @"sound" : sound,
                            @"senderID" : [PFUser currentUser].objectId,
                            @"WatchKit Simulator Actions": @[
                                    @{
                                       @"title": @"Revenge",
                                       @"identifier": @"takeRevenge"
                                    }
                                ],
                            };
    
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
