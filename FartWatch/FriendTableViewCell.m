//
//  FriendTableViewCell.m
//  FartWatch
//
//  Created by Jake Saferstein on 2/26/15.
//  Copyright (c) 2015 Jake Saferstein. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _secondsLeft = 0;
    }
    return self;
}

-(void)setUser:(PFUser *)user
{
    _user = user;
    
    self.textLabel.text = user[@"name"];
    NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", user[@"fbId"]]]];
    self.imageView.image = [UIImage imageWithData:imgData];
//    self.detailTextLabel.text = @"Ready to fart again";
    
}

-(void)setUserId2: (NSString *)userId
{
    _userId = userId;
}

-(void)setUserId:(NSString *)userId
{
    _userId = userId;
    PFQuery* temp = [PFUser query];
    
    [temp getObjectInBackgroundWithId:userId block:^(PFObject *object, NSError *error) {
        [self setUser: (PFUser *)object];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)startTimer
{
    _secondsLeft = 30;
    _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
}

-(void) updateCountdown
{
    if (_secondsLeft == 0) {
        [_timer invalidate];
        self.detailTextLabel.text = @"Ready to fart again";
        return;
    }
    _secondsLeft--;
    int minutes = _secondsLeft / 60;
    int seconds = _secondsLeft % 60;
    
    self.detailTextLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];

}

@end
