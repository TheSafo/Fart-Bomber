//
//  ViewController.m
//  FartWatch
//
//  Created by Jake Saferstein on 2/2/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "MainViewController.h"
#import <Pop/POP.h>

#warning TODO LIST:
//Animated Chair background
//Vibration
//Custom Image
//UIImagePicker

#define HEIGHT (self.view.frame.size.height - 54)
#define WIDTH self.view.frame.size.width


@interface MainViewController ()


@property(nonatomic) UIImage* img2; /* Stores image from init for use later*/

@property(nonatomic) int dontPlayUntil;

@end

@implementation MainViewController

-(id)initWithImg: (UIImage *) img {
    if (self = [super init]) {
        
        self.title = @"Fart Bomber";
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsPressed:)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor grayColor];
        
//        _camBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        _camBtn.imageView.image = [UIImage imageNamed:@"camera44"];
        
        _img2 = img;
        
        NSString* fart1 = [[NSBundle mainBundle] pathForResource:@"fart1" ofType:@"mp3"];
        NSURL* fart1URL = [NSURL fileURLWithPath:fart1];
        _plyr1 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart1URL error:nil];
        
        NSString* fart2 = [[NSBundle mainBundle] pathForResource:@"fart2" ofType:@"wav"];
        NSURL* fart2URL = [NSURL fileURLWithPath:fart2];
        _plyr2 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart2URL error:nil];
        
        NSString* fart3 = [[NSBundle mainBundle] pathForResource:@"fart3" ofType:@"wav"];
        NSURL* fart3URL = [NSURL fileURLWithPath:fart3];
        _plyr3 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart3URL error:nil];
        
        NSString* fart4 = [[NSBundle mainBundle] pathForResource:@"fart4" ofType:@"wav"];
        NSURL* fart4URL = [NSURL fileURLWithPath:fart4];
        _plyr4 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart4URL error:nil];
        
        NSString* fart5 = [[NSBundle mainBundle] pathForResource:@"fart5" ofType:@"wav"];
        NSURL* fart5URL = [NSURL fileURLWithPath:fart5];
        _plyr5 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart5URL error:nil];
        
        NSString* fart6 = [[NSBundle mainBundle] pathForResource:@"fart6" ofType:@"wav"];
        NSURL* fart6URL = [NSURL fileURLWithPath:fart6];
        _plyr6 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart6URL error:nil];
        
        NSString* fart7 = [[NSBundle mainBundle] pathForResource:@"fart7" ofType:@"mp3"];
        NSURL* fart7URL = [NSURL fileURLWithPath:fart7];
        _plyr7 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart7URL error:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _blendVw = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/16, 54 + HEIGHT/16, WIDTH*7/8 ,HEIGHT*3/4)];
//    _camBtn.frame = CGRectMake(WIDTH*15/16, 54 + HEIGHT*15/16, WIDTH/16, WIDTH/16);
    
//    [self.view addSubview:_camBtn];
    
    UIImage* temp = [self mergeTwoImages: [UIImage imageNamed:@"testImg.png"]: _img2];
    _blendVw.image = temp;
    [self.view addSubview:_blendVw];
}

-(void)settingsPressed: (UIButton*) btn
{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch* touch = [touches anyObject];
    
//    CGPoint loc = [touch locationInView:self.view];
//    NSLog(@"%f, %f", loc.x, loc.y);
    
    if(CFAbsoluteTimeGetCurrent() < _dontPlayUntil)
    {
//        NSLog(@"TOO SOON");
    }
    else
    {
        [self fartNoise];
    }
}

-(void)fartimateWithDur: (float) dur;
{
    [self applyEarthquakeToView:_blendVw duration:1.0f delay:0 offset:2000];
}

- (void) applyEarthquakeToView:(UIView*)v duration:(float)duration delay:(float)delay offset:(int)offset {
    
    CAKeyframeAnimation *transanimation;
    transanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transanimation.duration = duration;
    transanimation.cumulative = YES;
    int offhalf = offset / 2;
    
    int numFrames = 10;
    NSMutableArray *positions = [NSMutableArray array];
    NSMutableArray *keytimes  = [NSMutableArray array];
    NSMutableArray *timingfun = [NSMutableArray array];
    [positions addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [keytimes addObject:@(0)];
    
    for (int i = 0; i < numFrames; i++) {
        CATransform3D beforeScale = CATransform3DMakeTranslation(rand()%offset-offhalf, rand()%offset-offhalf,0);
        
        beforeScale = CATransform3DRotate(beforeScale, M_PI_4/2 * pow(-1, i), 0, 0, 1);
        
        CATransform3D final = CATransform3DScale(beforeScale, i, i, 0);
        
        [positions addObject:[NSValue valueWithCATransform3D:final]];
        
        [keytimes addObject:@( ((float)(i+1))/(numFrames+2) )];
        [timingfun addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    }
    
    [positions addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [keytimes addObject:@(1)];
    [timingfun addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    transanimation.values = positions;
    transanimation.keyTimes = keytimes;
    transanimation.calculationMode = kCAAnimationCubic;
    transanimation.timingFunctions = timingfun;
    transanimation.beginTime = CACurrentMediaTime() + delay;
    
    [v.layer addAnimation:transanimation forKey:nil];
}

-(void)fartNoise
{
    int x = arc4random_uniform(6) + 1;
    
    AVAudioPlayer* temp;
    
    switch (x) {
        case 1:
            temp = _plyr1;
            break;
        case 2:
            temp = _plyr2;
            break;
        case 3:
            temp = _plyr3;
            break;
        case 4:
            temp = _plyr4;
            break;
        case 5:
            temp = _plyr5;
            break;
        case 6:
            temp = _plyr6;
            break;
        case 7:
            temp = _plyr7;
            break;
    }
    
    double y = CFAbsoluteTimeGetCurrent();
    y+= temp.duration;
    
    _dontPlayUntil = y;
    
    [temp play];
    [self applyEarthquakeToView:_blendVw duration:temp.duration delay:0 offset:200];
}



- (UIImage*) mergeTwoImages : (UIImage*) topImage : (UIImage*) bottomImage
{
    // URL REF: http://iphoneincubator.com/blog/windows-views/image-processing-tricks
    // URL REF: http://stackoverflow.com/questions/1309757/blend-two-uiimages?answertab=active#tab-top
    // URL REF: http://www.waterworld.com.hk/en/blog/uigraphicsbeginimagecontext-and-retina-display
    
    int width = _blendVw.frame.size.width;//bottomImage.size.width;
    int height = _blendVw.frame.size.height;//bottomImage.size.height;
    
    CGSize newSize = CGSizeMake(width, height);
    NSLog(@"%i, %i", width, height);
    static CGFloat scale = -1.0;
    
    if (scale<0.0)
    {
        UIScreen *screen = [UIScreen mainScreen];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
        {
            scale = [screen scale];
        }
        else
        {
            scale = 0.0;    // Use the standard API
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);

    
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    [topImage drawInRect:CGRectMake(newSize.width/8,newSize.height/16,newSize.width*3/4,newSize.height*5/8) blendMode:kCGBlendModeNormal alpha:.75];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end