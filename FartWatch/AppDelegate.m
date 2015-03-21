//
//  AppDelegate.m
//  FartWatch
//
//  Created by Jake Saferstein on 2/2/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>


@interface AppDelegate ()

@property(nonatomic) MainViewController* mainCtrlr;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.tintColor = [UIColor blackColor];
    
    
    [[StoreManager sharedInstance] updatePurchaseInfo];
    
    
    [AdSingleton sharedInstance].adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.window.frame.size.height, self.window.frame.size.width, 50)];//CGRectMake(0, 50 + self.view.frame.size.height, self.view.frame.size.width, 50)]; ///Off the screen initially
    [AdSingleton sharedInstance].adBanner.delegate = [AdSingleton sharedInstance];
    
    
    _navCtrlr = [[UINavigationController alloc]  init];
    
    _wormHole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.gmail.jakesafo.fartbomber"
                                           optionalDirectory:@"wormhole"];
    
    
    [Parse setApplicationId:@"U3jYooMOP5sHRj6R9WYR6cwzE3vQQavKBPF1jJ80" clientKey:@"gVOe8Xxnn1RymITkY7ddbNiP396IvrdMyy8vf4k6"];
    
    [PFFacebookUtils initializeFacebook];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];    
    
    /** Start Audio for the app */
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
//    NSData* imgData = [_wormHole messageWithIdentifier:@"rawImg"];
    UIImage* initImg = [_wormHole messageWithIdentifier:@"rawImg"];
    
//    /** If there's no data, set a default image */
//    if(!imgData)
//    {
//        initImg = nil;
//    }
//    else
//    {
//        initImg = [UIImage imageWithData:imgData];
//    }

    long cushionNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"cushNum"];
    if (!cushionNum) {
        cushionNum = 5;
    }
    
    
    /** Show the controller! */
    _mainCtrlr = [[MainViewController alloc] initWithImg:initImg andNum:cushionNum];
    [_navCtrlr pushViewController:_mainCtrlr animated:YES];
    [self.window setRootViewController:_navCtrlr];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    
    if([PFUser currentUser])
    {
        currentInstallation[@"user"] = [PFUser currentUser];
    }
    [currentInstallation saveInBackground];
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if(_isActive)
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self fart];
    }
}

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
        
        int x = arc4random_uniform(7) + 1;
        NSString* sound = [NSString stringWithFormat:@"fart%i.caf", x]; ///Randomizes sound!!!
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = @"FART BOMBED";
        notification.soundName = sound;
        
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
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PFFacebookUtils session] close];
}

@end
