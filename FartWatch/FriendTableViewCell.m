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
    _user = user;
    
    self.textLabel.text = user[@"name"];
    NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", user[@"fbId"]]]];
    self.imageView.image = [UIImage imageWithData:imgData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
