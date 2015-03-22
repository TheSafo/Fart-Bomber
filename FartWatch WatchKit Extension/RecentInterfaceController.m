//
//  RecentInterfaceController.m
//  FartWatch
//
//  Created by Jake Saferstein on 3/21/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "RecentInterfaceController.h"
#import "SAFRowController.h"


@interface RecentInterfaceController()

@property (nonatomic) NSArray* names;
@property (nonatomic) NSArray* pics;


@end


@implementation RecentInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    
    _wormHole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.gmail.jakesafo.fartbomber"
                                                     optionalDirectory:@"wormhole"];
    
    /** Listen for updates */
    [_wormHole listenForMessageWithIdentifier:@"recDic" listener:^(id messageObject) {

        
    }];
    
    
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

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



