//
//  SettingsViewController.m
//  FartWatch
//
//  Created by Jake Saferstein on 3/16/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "StoreManager.h"
#import "SettingsViewController.h"
#import "AdSingleton.h"
#import "MainViewController.h"

@interface SettingsViewController ()

@property (nonatomic) UIButton* restore;
//@property (nonatomic) UIButton* purchaseAds;
//@property (nonatomic) UIButton* purchaseCustom;
@property (nonatomic) UIPickerView* changeCushion;
@property (nonatomic) UIImageView* logo;

@property (nonatomic) long curNum;


@end

@implementation SettingsViewController

-(id)init
{
    if(self = [super init])
    {
        self.view = [[UIView alloc] initWithFrame:[[[[UIApplication sharedApplication] windows] firstObject] frame]];
        self.view.backgroundColor = [UIColor lightGrayColor];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain  target:self action:@selector(backPressed)];
        
        
        self.title = @"Settings";
        
        int w = self.view.frame.size.width;
        int h = self.view.frame.size.height;
        
        if(ADS_ON)
        {
            h = h -50;
            [self.view addSubview:[AdSingleton sharedInstance].adBanner];
        }
        
        _logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appiconlarge"] ];
        
        int size = (h*2/3 - h/4 - h/8 - 10);
        
        _logo.frame = CGRectMake(w/2 - size/2, h/8, size, size);
        _logo.layer.cornerRadius = w/8;
        _logo.layer.masksToBounds = YES;

        
        _restore = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _restore.frame = CGRectMake(w/8, h*2/3 - h/4, w*3/4, h/8);
        [_restore setTitle:@"Restore Purchases" forState:UIControlStateNormal];
        _restore.layer.cornerRadius = 10;
        _restore.backgroundColor = [UIColor grayColor];
        
        [_restore addTarget:self action:@selector(restorePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _changeCushion = [[UIPickerView alloc] initWithFrame:CGRectMake(w/8, h*2/3 - h/8, w*3/4, h/3)];
        _changeCushion.delegate = self;
        _changeCushion.dataSource = self;

        
        [self.view addSubview:_logo];
        [self.view addSubview:_changeCushion];
        [self.view addSubview:_restore];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    long initialNum = ((MainViewController *) self.navigationController.viewControllers[0]).cushNum;
    [_changeCushion selectRow:(initialNum-1) inComponent:0 animated:YES];
    _curNum = initialNum;
}

-(void)backPressed
{
    ((MainViewController *) self.navigationController.viewControllers[0]).cushNum = _curNum;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)restorePressed: (UIButton *)btn
{
    [[StoreManager sharedInstance] restorePurchase];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _curNum = row +1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    long r = row+1;
    
    NSString* str = [NSString stringWithFormat:@"Cushion %li", r];
    
    return str;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end
