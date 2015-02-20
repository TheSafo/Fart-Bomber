//
//  AppDelegate.m
//  FartWatch
//
//  Created by Jake Saferstein on 2/2/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    /** Ensure everything is loaded properly */
//    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"img"])
    {
        UIImage* def = [UIImage imageNamed:@"testCushion"];
        
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(def) forKey:@"img"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    _navCtrlr = [[UINavigationController alloc]  init];
    _navCtrlr.navigationBar.barTintColor = [UIColor redColor];
    

    MainViewController* temp = [[MainViewController alloc] initWithImg:[UIImage imageWithData:([[NSUserDefaults standardUserDefaults] objectForKey:@"img"])]];
    [_navCtrlr pushViewController:temp animated:YES];
    [self.window setRootViewController:_navCtrlr];
    
    
    
    [self.window makeKeyAndVisible];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
