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
        
    }
    return self;
}

-(void)setUser:(PFUser *)user
{
    if(!_userId)
    {
        _userId = user.objectId;
    }
    
    _user = (PFUser *)[user fetchIfNeeded];
    
    self.textLabel.text = user[@"name"];
    NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", user[@"fbId"]]]];
    self.imageView.image = [UIImage imageWithData:imgData];
}

-(void)setUserId:(NSString *)userId
{
    PFQuery* temp = [[PFUser query] whereKey:@"objectId" equalTo:userId];
    
    [temp getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        _userId = userId;
        [self setUser:(PFUser *)object];
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
