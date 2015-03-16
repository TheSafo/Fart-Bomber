//
//  SettingsViewController.m
//  FartWatch
//
//  Created by Jake Saferstein on 3/16/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (nonatomic) UIButton* restoreAds;
@property (nonatomic) UIButton* restoreCustom;
@property (nonatomic) UIButton* purchaseAds;
@property (nonatomic) UIButton* purchaseCustom;


@end

@implementation SettingsViewController

-(id)init
{
    if(self == [super init])
    {
        self.view = [[UIView alloc] initWithFrame:[[[[UIApplication sharedApplication] windows] firstObject] frame]];
        
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

#warning Add restore purchases, purachases, changing cushion





@end

