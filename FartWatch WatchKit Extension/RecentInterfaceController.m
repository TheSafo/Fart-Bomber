//
//  RecentInterfaceController.m
//  FartWatch
//
//  Created by Jake Saferstein on 3/21/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "RecentInterfaceController.h"
#import "SAFRowController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>


@interface RecentInterfaceController()

@property (nonatomic) PFUser* curUser;
@property (nonatomic) NSMutableArray* names;
@property (nonatomic) NSMutableArray* pics;
@property (nonatomic) NSMutableArray* theUsers;

@property (nonatomic) BOOL timerOn;


@end


@implementation RecentInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [Parse setApplicationId:@"U3jYooMOP5sHRj6R9WYR6cwzE3vQQavKBPF1jJ80" clientKey:@"gVOe8Xxnn1RymITkY7ddbNiP396IvrdMyy8vf4k6"];
        
    
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

    //Data to Swap
    NSString* sendName = _names[rowIndex];
    UIImage* sendImg = _pics[rowIndex];
    PFUser* sendUsr = _theUsers[rowIndex];
    
    //Swap everything to the front
    [_names removeObjectAtIndex:rowIndex];
    [_pics removeObjectAtIndex:rowIndex];
    [_theUsers removeObjectAtIndex:rowIndex];
    
    [_names insertObject:sendName atIndex:0];
    [_pics insertObject:sendImg atIndex:0];
    [_theUsers insertObject:sendUsr atIndex:0];

    //Update current user's revenge list
    NSMutableArray* temp = _curUser[@"revenge"];
    if([temp containsObject:userStr])
    {
        [temp removeObject:userStr];
        
        //Saves Revenge list
        [PFCloud callFunctionInBackground:@"editUser" withParameters:@{@"userId": _curUser.objectId, @"newRev":temp} block:^(id object, NSError *error) {
            if(error) { NSLog(@"Cloud error: %@", error); }
        }];
    }
    
    //Saves Recent list
    
    NSArray* newRec = [self usersToIDs:_theUsers];
    
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

-(void)updateCurUser
{
    NSString* usrID = _curUser.objectId;
    
    PFQuery* temp = [PFUser query];
    
    [temp getObjectInBackgroundWithId:usrID block:^(PFObject *object, NSError *error) {
        _curUser = (PFUser *) object;
    }];
}

-(void)reloadData
{
    [_names removeAllObjects];
    [_pics removeAllObjects];
    [_theUsers removeAllObjects];
    
    NSArray* recentUserIds = [_curUser valueForKey:@"recent"];
    
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

-(void)willActivate
{
    [super willActivate];
    
    if(_timerOn)
    {
        return;
    }
    
    if(_names.count >0)
    {
        [self.table setHidden:NO];
        [self.backLabel setHidden:YES];
        [self createTable]; //Not worth re-getting user recents on reload
    }
    else
    {
        [self.table setHidden:YES];
        [self.backLabel setHidden:NO];
        [self createPlaceHolder];
    }
}

-(void)createPlaceHolder
{
    [self.table setHidden:YES];
    [self.backLabel setHidden:NO];
}

-(void)createTable
{    
    [self.table setNumberOfRows:_names.count withRowType:@"SAFRowController"];
    
    [_names enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SAFRowController* row = [self.table rowControllerAtIndex:idx];
        [row.name setText: (NSString *)obj];
        [row.profPic setImage:_pics[idx]];
    }];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



