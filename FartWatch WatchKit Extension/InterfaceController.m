//
//  InterfaceController.m
//  FartWatch WatchKit Extension
//
//  Created by Jake Saferstein on 2/2/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "InterfaceController.h"
#import <Parse/Parse.h>


@interface InterfaceController()

@property (nonatomic) PFUser* curUser;
@property (nonatomic) PFUser* sendUsr;

@end


@implementation InterfaceController

-(void)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)remoteNotification
{
    if([identifier isEqualToString:@"takeRevenge"])
    {
        NSLog(@"Taking revnege");
        
        NSMutableDictionary* msg = [NSMutableDictionary dictionary];
        msg[@"operation"] = @"getUser";
        
        
        [WKInterfaceController openParentApplication:msg reply:^(NSDictionary *replyInfo, NSError *error) {
            NSString* curUsrID = replyInfo[@"user"];
            if (!curUsrID) {
                NSLog(@"Error getting user");
            }
            else
            {
                PFQuery* curUsrQuery = [PFUser query];
                [curUsrQuery getObjectInBackgroundWithId:curUsrID block:^(PFObject *object, NSError *error) {
                    
                    _curUser = (PFUser *)object;
                    
                    PFQuery* sendUsrQuery = [PFUser query];
                    
                    [sendUsrQuery getObjectInBackgroundWithId:remoteNotification[@"senderID"] block:^(PFObject *object, NSError *error) {
                        _sendUsr = (PFUser *)object;
                        [self startRevenge];
                    }];

                }];
            }
        }];

    }
}

-(void)startRevenge
{
    NSString* sendStr = _sendUsr.objectId;
    NSString* userStr = _curUser.objectId;
    
    NSMutableArray* newRec = _curUser[@"recent"];
    if ([newRec containsObject:sendStr]) {
        [newRec removeObject:sendStr];
    }
    if (newRec.count == 5) {
        [newRec removeLastObject];
    }
    [newRec insertObject:sendStr atIndex:0];
    
    [PFCloud callFunctionInBackground:@"editUserRec" withParameters:@{@"userId": _curUser.objectId, @"newRec":newRec} block:^(id object, NSError *error) {
        if(error) { NSLog(@"Cloud error: %@", error); }
    }];
    
    
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
    
    /** Send push */
    [self sendPushtoUser:_sendUsr withMsg:@"FART BOMBED"];
    
    /** Update on parse other user's revenge list */
    NSMutableArray* sendArr = [_sendUsr objectForKey:@"revenge"];
    
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

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    _wormHole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.gmail.jakesafo.fartbomber"
                                                     optionalDirectory:@"wormhole"];
    /** Get initial image */
    UIImage* initImg = [_wormHole messageWithIdentifier:@"curImg"];
    
    
    /** If there's no data, set a default image */
    if(initImg.size.width == 0 || initImg.size.height ==0)
    {
        initImg = [UIImage imageNamed:@"cushion2.png"];
    }
    [_myButton setBackgroundImage:initImg];
    
    
    
    /** Listen for updates */
    [_wormHole listenForMessageWithIdentifier:@"curImg" listener:^(id messageObject) {
        UIImage* newImg = messageObject;
        
        if(newImg.size.width == 0 || newImg.size.height ==0)
        {
            newImg = [UIImage imageNamed:@"cushion2.png"];
        }
        
        [_myButton setBackgroundImage:newImg];
    }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction) handleButton {
    NSLog(@"Fart pressed");
    
    /** Send a message to the client to get it to fart */
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    msg[@"operation"] = @"fart";
    
    [WKInterfaceController openParentApplication:msg reply:^(NSDictionary *replyInfo, NSError *error) {
//        NSString* temp = replyInfo[@"fartResp"];
    }];
}


@end



