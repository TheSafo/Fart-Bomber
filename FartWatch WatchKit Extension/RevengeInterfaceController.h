//
//  RevengeInterfaceController.h
//  FartWatch
//
//  Created by Jake Saferstein on 3/21/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface RevengeInterfaceController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceTable *table;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *backLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *sentLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceTimer *timer;

@end
