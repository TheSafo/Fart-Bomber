//
//  AppDelegate.h
//  FartWatch
//
//  Created by Jake Saferstein on 2/2/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import <MMWormhole/MMWormhole.h>

#warning Lets flurry this up

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) MMWormhole* wormHole;

@property (nonatomic) BOOL isActive;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) UINavigationController* navCtrlr;

@end

