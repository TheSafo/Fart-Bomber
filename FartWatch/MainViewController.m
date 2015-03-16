//
//  ViewController.m
//  FartWatch
//
//  Created by Jake Saferstein on 2/2/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "MainViewController.h"
#import <Pop/POP.h>
#include <math.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "FriendsListViewController.h"

#define HEIGHT (self.view.frame.size.height -54)
#define WIDTH self.view.frame.size.width
#define TOP_IMAGE_RECT CGRectMake(_blendVw.frame.size.width/8,_blendVw.frame.size.height/16,_blendVw.frame.size.width*3/4,_blendVw.frame.size.height*5/8)

@interface MainViewController ()


@property(nonatomic) UIImage* cushionImg; /* Stores image from init for use later*/

@property(nonatomic) int dontPlayUntil;

@property (nonatomic) int cushNum;




@end

@implementation MainViewController

-(id)initWithImg: (UIImage *) img andNum: (int) num{
    if (self = [super init]) {
        
        self.title = @"Fart Bomber";
        
//        UIImage* settingsImg = [UIImage imageNamed:@"nut4.png"];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain  target:self action:@selector(settingsPressed)];
        
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
        _camBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _camBtn.tintColor = [UIColor blackColor];
        
        _fbBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _fbBtn.tintColor = [UIColor blackColor];
        
        _cushionImg = img;
        _cushNum = num;
        
        NSString* fart1 = [[NSBundle mainBundle] pathForResource:@"fart1" ofType:@"caf"];
        NSURL* fart1URL = [NSURL fileURLWithPath:fart1];
        _plyr1 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart1URL error:nil];
        
        NSString* fart2 = [[NSBundle mainBundle] pathForResource:@"fart2" ofType:@"caf"];
        NSURL* fart2URL = [NSURL fileURLWithPath:fart2];
        _plyr2 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart2URL error:nil];
        
        NSString* fart3 = [[NSBundle mainBundle] pathForResource:@"fart3" ofType:@"caf"];
        NSURL* fart3URL = [NSURL fileURLWithPath:fart3];
        _plyr3 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart3URL error:nil];
        
        NSString* fart4 = [[NSBundle mainBundle] pathForResource:@"fart4" ofType:@"caf"];
        NSURL* fart4URL = [NSURL fileURLWithPath:fart4];
        _plyr4 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart4URL error:nil];
        
        NSString* fart5 = [[NSBundle mainBundle] pathForResource:@"fart5" ofType:@"caf"];
        NSURL* fart5URL = [NSURL fileURLWithPath:fart5];
        _plyr5 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart5URL error:nil];
        
        NSString* fart6 = [[NSBundle mainBundle] pathForResource:@"fart6" ofType:@"caf"];
        NSURL* fart6URL = [NSURL fileURLWithPath:fart6];
        _plyr6 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart6URL error:nil];
        
        NSString* fart7 = [[NSBundle mainBundle] pathForResource:@"fart7" ofType:@"caf"];
        NSURL* fart7URL = [NSURL fileURLWithPath:fart7];
        _plyr7 = [[AVAudioPlayer alloc] initWithContentsOfURL:fart7URL error:nil];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(ADS_ON)
    {
        int h = HEIGHT - 50;
        
        _blendVw.frame = CGRectMake(WIDTH/16, 54 + h/16, WIDTH*7/8 ,h*13/16);
        _camBtn.frame = CGRectMake(WIDTH*15/16 - h/8, 54 + h*14/16, h/8, h/8);
        _fbBtn.frame = CGRectMake(WIDTH*1/16, 54 + h*14/16, h/8, h/8);
        
    }
    else
    {
        _blendVw.frame = CGRectMake(WIDTH/16, 54 + HEIGHT/16, WIDTH*7/8 ,HEIGHT*13/16);
        _camBtn.frame = CGRectMake(WIDTH*15/16 - HEIGHT/8, 54 + HEIGHT*14/16, HEIGHT/8, HEIGHT/8);
        _fbBtn.frame = CGRectMake(WIDTH*1/16, 54 + HEIGHT*14/16,  HEIGHT/8,  HEIGHT/8);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView* bckgd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"testBackground.jpg"]];
    
    bckgd.frame = self.view.bounds;
    
    [self.view addSubview:bckgd];
    
    if(ADS_ON)
    {
        int h = HEIGHT - 50;

        _blendVw = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/16, 54 + h/16, WIDTH*7/8 ,h*13/16)];
        
    }
    else{
        _blendVw = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/16, 54 + HEIGHT/16, WIDTH*7/8 ,HEIGHT*13/16)];
    }

    
    [_camBtn setImage:[UIImage imageNamed:@"camera44.png"] forState:UIControlStateNormal];
    [_camBtn setImage:[UIImage imageNamed:@"camera44.png"] forState:UIControlStateSelected];
    [_camBtn addTarget:self action:@selector(camPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [_fbBtn setImage:[UIImage imageNamed:@"group4.png"] forState:UIControlStateNormal];
    [_fbBtn setImage:[UIImage imageNamed:@"group4.png"] forState:UIControlStateSelected];
    
    [_fbBtn addTarget:self action:@selector(fbPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _blendVw.image = _cushionImg;
    
    [self.view addSubview:_camBtn];
    [self.view addSubview:_fbBtn];
    [self.view addSubview:_blendVw];
    if(ADS_ON)
    {
        [self.view addSubview:[AdSingleton sharedInstance].adBanner];
    }

}




-(void)fbPressed
{
    IntermediateViewController* toPush = [[IntermediateViewController alloc] init];
    [self.navigationController pushViewController:toPush animated:YES];
    
    
//    [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
    
//    [AdSingleton sharedInstance].adBanner.frame = CGRectOffset([AdSingleton sharedInstance].adBanner.frame, 0, [AdSingleton sharedInstance].adBanner.frame.size.height);
//    [UIView commitAnimations];
//    [AdSingleton sharedInstance].bannerIsVisible = NO;
}

-(void)camPressed
{
    _actnSht = [[UIActionSheet alloc] initWithTitle:@"Change Cushion Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose a photo", @"Take a photo", nil];
    
    [_actnSht showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = YES;
    
    if(buttonIndex == 0)
    {
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if(buttonIndex == 1)
    {
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
        return;
    }
    
    [self presentViewController:_picker animated:YES completion:^{
        NSLog(@"Presenting imagePicker");
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* temp = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self changeImage:temp];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissing Image Picker");
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissing Image Picker");
    }];
}

-(void)changeImage: (UIImage *)newImg
{
    UIImage* temp = [self imageFromNum];
    UIImage* newBlend = [self mergeTwoImages:[self circularScaleAndCropImage:newImg frame:TOP_IMAGE_RECT] :temp];
    
    _blendVw.image = newBlend;
    NSData* imgData = UIImagePNGRepresentation(newBlend);
    
    /** Send the image through the wormhole */
    [((AppDelegate *)[UIApplication sharedApplication].delegate).wormHole passMessageObject:imgData identifier:@"curImg"];
}


-(UIImage *)imageFromNum
{
    NSString* str = [NSString stringWithFormat:@"cushion%i",_cushNum];

    UIImage* temp = [UIImage imageNamed:str];
    
    return temp;
}

- (UIImage*)circularScaleAndCropImage:(UIImage*)image frame:(CGRect)frame {
    // This function returns a newImage, based on image, that has been:
    // - scaled to fit in (CGRect) rect
    // - and cropped within a circle of radius: rectWidth/2
    
    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rectWidth = frame.size.width;
    CGFloat rectHeight = frame.size.height;
    
    //Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;
    
    //Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


-(void)settingsPressed
{
    [self.navigationController pushViewController: [[SettingsViewController alloc] init] animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    
    CGPoint loc = [touch locationInView:_blendVw];
    
//    NSLog(@"%f, %f", loc.x, loc.y);
    
    if(CFAbsoluteTimeGetCurrent() < _dontPlayUntil)
    {
        NSLog(@"TOO SOON");
    }
    else if (loc.x < 0 || loc.y <0 || loc.y > _blendVw.frame.size.height || loc.x > _blendVw.frame.size.width)
    {
        NSLog(@"Didn't touch the cushion");
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
    int x = arc4random_uniform(7) + 1;
    
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
    
    int endAtTime = temp.duration/.4 - .4;
    if(endAtTime < 0)
    {
        endAtTime = 1;
    }
    
    for (int i = 0; i < endAtTime; i++)
    {
        [self performSelector:@selector(vibe:) withObject:self afterDelay:i *.4f];
    }
    [self applyEarthquakeToView:_blendVw duration:temp.duration delay:0 offset:200];
}

-(void)vibe:(id)sender
{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

- (UIImage*) mergeTwoImages : (UIImage*) topImage : (UIImage*) bottomImage
{
    int width = _blendVw.frame.size.width;//bottomImage.size.width;
    int height = _blendVw.frame.size.height;//bottomImage.size.height;
    
    CGSize newSize = CGSizeMake(width, height);
//    NSLog(@"%i, %i", width, height);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    [topImage drawInRect:TOP_IMAGE_RECT blendMode:kCGBlendModeNormal alpha:.65];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end