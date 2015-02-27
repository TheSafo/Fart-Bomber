//
//  InterfaceController.h
//  FartWatch WatchKit Extension
//
//  Created by Jake Saferstein on 2/2/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "MMWormhole.h"

@interface InterfaceController : WKInterfaceController

+(NSURL*)getSharedContainerURLPath;
+(void)createDirAtSharedContainerPath;

@property (nonatomic) IBOutlet WKInterfaceButton* myButton;

@property (nonatomic) MMWormhole* wormHole;


@end
