//
//  InterfaceController.m
//  FartWatch WatchKit Extension
//
//  Created by Jake Saferstein on 2/2/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    
    /** Get initial image */
    NSString* imgPath = [[InterfaceController getSharedContainerURLPath] path];
    imgPath = [imgPath stringByAppendingPathComponent:@"curImg.saf"];
    NSData* imgData = [NSData dataWithContentsOfFile:imgPath];

    NSLog(@"%@",imgPath);
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
    /** Set Initial Image */
    [_myButton setBackgroundImage:initImg];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction) handleButton {
    NSLog(@"Fart pressed");
    
    /** Send a message to the client to get it to fart */
    NSMutableDictionary* msg = [NSMutableDictionary dictionary];
    msg[@"operation"] = @"fart";
    
    [WKInterfaceController openParentApplication:msg reply:^(NSDictionary *replyInfo, NSError *error) {
        NSString* temp = replyInfo[@"fartResp"];
        NSLog(temp);
    }];
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


@end



