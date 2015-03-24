//
//  SAFRowController.h
//  FartWatch
//
//  Created by Jake Saferstein on 3/21/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface SAFRowController : NSObject

@property (strong, nonatomic) IBOutlet WKInterfaceImage *profPic;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *name;


@end
