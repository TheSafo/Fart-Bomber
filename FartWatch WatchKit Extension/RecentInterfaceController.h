//
//  RecentInterfaceController.h
//  FartWatch
//
//  Created by Jake Saferstein on 3/21/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "MMWormhole.h"


@interface RecentInterfaceController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceTable *table;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *backLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceTimer *timer;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *sentLabel;

@end
