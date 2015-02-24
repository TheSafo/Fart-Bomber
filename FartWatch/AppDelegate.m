//
//  AppDelegate.m
//  FartWatch
//
//  Created by Jake Saferstein on 2/2/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property(nonatomic) MainViewController* mainCtrlr;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    _navCtrlr = [[UINavigationController alloc]  init];
    _navCtrlr.navigationBar.barTintColor = [UIColor redColor];
    
    /** Start Audio for the app */
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    /** Get initial image */
    NSString* imgPath = [[AppDelegate getSharedContainerURLPath] path];
    imgPath = [imgPath stringByAppendingPathExtension:@"curImg.saf"];
    NSURL* imgURL = [NSURL URLWithString:imgPath];
    NSData* imgData = [NSData dataWithContentsOfURL:imgURL];
    
    UIImage* initImg;
    
    /** If there's no data, set a default image */
    if(!imgData)
    {
        initImg = [UIImage imageNamed:@"cushion3"];
    }
    else
    {
        initImg = [UIImage imageWithData:imgData];
    }
    
    /** Show the controller! */
    _mainCtrlr = [[MainViewController alloc] initWithImg:initImg];
    [_navCtrlr pushViewController:_mainCtrlr animated:YES];
    [self.window setRootViewController:_navCtrlr];
    [self.window makeKeyAndVisible];
    
    return YES;
}

+(void)createDirAtSharedContainerPath
{
    NSString *sharedContainerPathLocation = [[self getSharedContainerURLPath] path];
    NSString *directoryToCreate = @"currentPicDir";
    //basically this is <shared_container_file_path>/user_abc
    NSString *dirPath = [sharedContainerPathLocation stringByAppendingPathComponent:directoryToCreate];
    
    BOOL isdir;
    NSError *error = nil;
    
    NSFileManager *mgr = [[NSFileManager alloc]init];
    
    if (![mgr fileExistsAtPath:dirPath isDirectory:&isdir]) { //create a dir only that does not exists
        if (![mgr createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"error while creating dir: %@", error.localizedDescription);
        } else {
            NSLog(@"dir was created....");
        }
    }
}

+(NSURL*)getSharedContainerURLPath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *appGroupName = @"group.com.gmail.jakesafo.fartbomber";
    
    NSURL *groupContainerURL = [fm containerURLForSecurityApplicationGroupIdentifier:appGroupName];
    
    return groupContainerURL;
}

#warning Watchkit
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply
{
    if([userInfo[@"operation"] isEqualToString:@"fart"])
    {
        NSLog(@"Replying to Watch fart");
        reply(@{@"fartResp":@"It works!"});
        [self fart];
    }
    else{
        NSLog(@"Open Parent Application message not handled properly");
    }
}

-(void)fart
{
    if(_isActive)
    {
        [_mainCtrlr fartNoise];
    }
    else
    {
        NSLog(@"Sending local notification");
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date];
        notification.timeZone = [NSTimeZone defaultTimeZone];
#warning Randomize these options later
        notification.alertBody = @"[FARTING INTENSIFIES]";
        notification.soundName = @"fart1.wav";
#warning Testing badges cuz yolo
        notification.applicationIconBadgeNumber = 7;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    _isActive = NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    _isActive = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
