//
//  RevengeInterfaceController.m
//  FartWatch
//
//  Created by Jake Saferstein on 3/21/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "RevengeInterfaceController.h"
#import "SAFRowController2.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>


@interface RevengeInterfaceController()

@property (nonatomic) PFUser* curUser;
@property (nonatomic) NSMutableArray* names;
@property (nonatomic) NSMutableArray* pics;
@property (nonatomic) NSMutableArray* theUsers;

@property (nonatomic) BOOL timerOn;


@end


@implementation RevengeInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    _names = [NSMutableArray array];
    _pics = [NSMutableArray array];
    _theUsers = [NSMutableArray array];
    
    
    [self getUser];
}

-(void)getUser
{
    /** Get the current user */
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    msg[@"operation"] = @"getUser";
    
    
    [WKInterfaceController openParentApplication:msg reply:^(NSDictionary *replyInfo, NSError *error) {
        NSString* curUsrID = replyInfo[@"user"];
        if (!curUsrID) {
            [self createPlaceHolder];
            NSLog(@"Test response: %@", replyInfo[@"test"]);
        }
        else
        {
            PFQuery* curUsrQuery = [PFUser query];
            [curUsrQuery getObjectInBackgroundWithId:curUsrID block:^(PFObject *object, NSError *error) {
                
                _curUser = (PFUser *)object;
                
                [self reloadData];
            }];
        }
    }];
}

-(void)timerDone
{
    [self.timer setHidden:YES];
    [self.sentLabel setHidden:NO];
    
    [self performSelector:@selector(reshowTable) withObject:nil afterDelay:3];
}

-(void)reshowTable
{
    [self.sentLabel setHidden:YES];
    [self.table setHidden:NO];
    _timerOn = NO;
}


-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    [self.table setHidden:YES];
    [self.timer setHidden:NO];
    
    int x = arc4random_uniform(10) + 5;
    
    [NSTimer scheduledTimerWithTimeInterval:x target:self selector:@selector(timerDone) userInfo:nil repeats:NO];
    [self.timer setDate:[NSDate dateWithTimeIntervalSinceNow:x]];
    [self.timer start];
    _timerOn = YES;


    NSString* sendStr = ((PFUser *)_theUsers[rowIndex]).objectId;
    NSString* userStr = _curUser.objectId;
    PFUser* sendUsr = _theUsers[rowIndex];
    
    //Remove that user from revenge once revenge is served
    [_names removeObjectAtIndex:rowIndex];
    [_pics removeObjectAtIndex:rowIndex];
    [_theUsers removeObjectAtIndex:rowIndex];
    
    NSMutableArray* newRev = [self usersToIDs:_theUsers];
    NSMutableArray* newRec = _curUser[@"recent"];
    
    if([newRec containsObject:sendStr])
    {
        [newRec removeObject:sendStr];
    }
    if(newRec.count == 5)
    {
        [newRec removeLastObject];
    }
    [newRec insertObject:sendStr atIndex:0];
    
    //Saves Revenge list
    [PFCloud callFunctionInBackground:@"editUser" withParameters:@{@"userId": _curUser.objectId, @"newRev":newRev} block:^(id object, NSError *error) {
        if(error) { NSLog(@"Cloud error: %@", error); }
    }];
    
    //Saves Recent list
    [PFCloud callFunctionInBackground:@"editUserRec" withParameters:@{@"userId": _curUser.objectId, @"newRec":newRec} block:^(id object, NSError *error) {
        if(error) { NSLog(@"Cloud error: %@", error); }
    }];

    
    [self createTable];
    
    
    /** Send push */
    [self sendPushtoUser:sendUsr withMsg:@"FART BOMBED"];
    
    /** Update on parse other user's revenge list */
    NSMutableArray* sendArr = [sendUsr objectForKey:@"revenge"];
    
    if([sendArr containsObject:userStr])
    {
        [sendArr removeObject:userStr];
    }
    if (sendArr.count == 5) {
        [sendArr removeLastObject];
    }
    [sendArr insertObject:userStr atIndex:0];
    
    [PFCloud callFunctionInBackground:@"editUser" withParameters:@{@"userId": sendStr, @"newRev":sendArr} block:^(id object, NSError *error) {
        if(error) { NSLog(@"Cloud error: %@", error); }
    }];
}

-(void)sendPushtoUser: (PFUser *)toSend withMsg: (NSString *) msg
{
    PFQuery *qry = [PFInstallation query];
    [qry whereKey:@"user" equalTo:toSend];
    
    NSString* realMsg = [NSString stringWithFormat:@"%@ from %@'s watch", msg, _curUser[@"name"]];
    
    int x = arc4random_uniform(7) + 1;
    NSString* sound = [NSString stringWithFormat:@"fart%i.caf", x]; ///Randomizes sound!!!
    
    NSDictionary *data = @{ @"alert" : realMsg,
                            @"sound" : sound,
                            @"senderID" : _curUser.objectId,
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

-(NSMutableArray *) usersToIDs: (NSMutableArray *) arr
{
    NSMutableArray* ids = [NSMutableArray array];
    
    for (PFUser* usr in arr) {
        [ids addObject:usr.objectId];
    }
    return ids;
}

-(void)createPlaceHolder
{
    [self.table setHidden:YES];
    [self.backLabel setHidden:NO];
}



-(void)updateCurUser
{
    NSString* usrID = _curUser.objectId;
    
    PFQuery* temp = [PFUser query];
    
    [temp getObjectInBackgroundWithId:usrID block:^(PFObject *object, NSError *error) {
        _curUser = (PFUser *) object;
    }];
}


-(void)createTable
{
    if(_names.count <= 0)
    {
        [self createPlaceHolder];
        return;
    }

    [self.table setNumberOfRows:_names.count withRowType:@"SAFRowController2"];
    
    [_names enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SAFRowController2* row = [self.table rowControllerAtIndex:idx];
        [row.name setText: (NSString *)obj];
        [row.profPic setImage:_pics[idx]];
    }];
}


-(void)reloadData
{
    [_names removeAllObjects];
    [_pics removeAllObjects];
    [_theUsers removeAllObjects];
    
    NSArray* recentUserIds = [_curUser valueForKey:@"revenge"];
    
    if(recentUserIds.count == 0)
    {
        [self createPlaceHolder];
        return;
    }
    
    for (NSString* usrID in recentUserIds) {
        PFQuery* temp = [PFUser query];
        
        [temp getObjectInBackgroundWithId:usrID block:^(PFObject *object, NSError *error) {
            PFUser* tempUsr = (PFUser *) object;
            [_names addObject:tempUsr[@"name"]];
            [_theUsers addObject:tempUsr];
            
            NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", tempUsr[@"fbId"]]]];
            UIImage* img = [UIImage imageWithData:imgData];
            [_pics addObject:img];
            
            [self createTable];
        }];
    }
}


- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    if(_timerOn)
    {
        return;
    }
    [self.backLabel setHidden:YES];
    [self.table setHidden:NO];
    [self getUser];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



