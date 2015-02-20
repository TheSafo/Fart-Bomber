//
//  ViewController.h
//  FartWatch
//
//  Created by Jake Saferstein on 2/2/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

//#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MainViewController : UIViewController

@property (nonatomic) UIImageView* blendVw;
//@property (nonatomic) UIButton* camBtn;


-(id)initWithImg: (UIImage *) img;
@property (nonatomic,strong) AVAudioPlayer *plyr1;
@property (nonatomic,strong) AVAudioPlayer *plyr2;
@property (nonatomic,strong) AVAudioPlayer *plyr3;
@property (nonatomic,strong) AVAudioPlayer *plyr4;
@property (nonatomic,strong) AVAudioPlayer *plyr5;
@property (nonatomic,strong) AVAudioPlayer *plyr6;
@property (nonatomic,strong) AVAudioPlayer *plyr7;





@end