//
//  FriendsListViewController.m
//  
//
//  Created by Jake Saferstein on 2/26/15.
//
//

#import "FriendsListViewController.h"
#import "FBLoginController.h"

@interface FriendsListViewController ()

@end

@implementation FriendsListViewController

-(id)initWithStyle:(UITableViewStyle)style
{
    if((self = [super initWithStyle:style]))
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        _shouldntUseThis = NO;
    }
    return self;
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
    [self.tableView reloadData];
}

-(void)setFriends:(NSArray *)friends
{
    _friends = friends;
    [self.tableView reloadData];
    _shouldntUseThis = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.title = @"Send Farts";
    
//    NSArray* arr1 = ((NSArray *)[PFUser currentUser][@"recent"]);
//    NSArray* arr2 = ((NSArray *)[PFUser currentUser][@"revenge"]);
//    
//    _recent = [NSMutableArray array];
//    _revenge = [NSMutableArray array];
//
//    
//    for (PFUser* usr in arr1) {
//        [_recent addObject:[usr fetchIfNeeded]];
//    }
//    
//    for (PFUser* usr in arr2) {
//        [_revenge addObject:[usr fetchIfNeeded]];
//    }
//    
//    
//    if(!_recent || [_recent isEqual:[NSNull null]])
//    {
//        _recent = [NSMutableArray array];
//        [PFUser currentUser][@"recent"] = _recent.copy;
//    }
//    if(!_revenge || [_revenge isEqual:[NSNull null]])
//    {
//        _revenge = [NSMutableArray array];
//        [PFUser currentUser][@"revenge"] = _revenge.copy;
//    }
//    [PFUser currentUser][@"recent"] = [NSMutableArray array];
//
//    [[PFUser currentUser] saveInBackground];
    
    _recentIds = [PFUser currentUser][@"recent"] = [NSMutableArray array];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if(!_shouldntUseThis)
    {
        [self.navigationController pushViewController: [[FBLoginController alloc] init] animated:YES];
    }
    else {
//        _revengeIds = [PFUser currentUser][@"revenge"];
//        _recentIds = [PFUser currentUser][@"recent"];
//        
//        if(!_recentIds || [_recentIds isEqual:[NSNull null]])
//        {
//            _recentIds = [NSMutableArray array];
//            [PFUser currentUser][@"recent"] = _recentIds.copy;
//        }
//        if(!_revengeIds || [_revengeIds isEqual:[NSNull null]])
//        {
//            _revengeIds = [NSMutableArray array];
//            [PFUser currentUser][@"revenge"] = _revengeIds.copy;
//        }
        _recentIds = [PFUser currentUser][@"recent"] = [NSMutableArray array];

        [[PFUser currentUser] saveInBackground];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Revenge";
            break;
        case 1:
            sectionName = @"Recent";
            break;
        case 2:
            sectionName = @"Friends";
            break;
    }
    return sectionName;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFUser* toSend;
    NSArray* arr;
    
    switch (indexPath.section) {
        case 0:
            arr = _revengeIds;
            break;
        case 1:
            arr = _recentIds;
            break;
        case 2:
            arr = _friends;
            break;
    }
    
    
    toSend = arr[indexPath.row];

    
    PFQuery *qry = [PFInstallation query];
    [qry whereKey:@"user" equalTo:toSend];
    //Brendan is the best!
    
    PFPush *push = [[PFPush alloc] init];
    
    NSString* msg = [NSString stringWithFormat:@"FART BOMBED by %@", [PFUser currentUser][@"name"]];

    [push setQuery:qry];
    NSDictionary *data = @{
        @"alert" : msg,
        @"sound" : @"fart1.caf",
    };
    [push setData:data];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        NSLog(@"push error %@", error);
    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /** Also update revenge and recent for both people */
    
//    for (PFUser* usr in _recent) {
//        [usr fetchIfNeeded];
//    }
    
    if(_recentIds.count == 5)
    {
        if([_recentIds containsObject:toSend.objectId])
        {
            [_recentIds removeObject:toSend.objectId];
        }
        else
        {
            [_recentIds removeLastObject];
        }
        
        [_recentIds insertObject:toSend.objectId atIndex:0];
    }
    else
    {
        if([_recentIds containsObject:toSend.objectId])
        {
            [_recentIds removeObject:toSend.objectId];
        }
        
        [_recentIds insertObject:toSend atIndex:0];
    }

    [self.tableView reloadData];
    
    [PFUser currentUser][@"recent"] = _recentIds.copy;
    
    [[PFUser currentUser] saveInBackground];
    
    NSArray* theirRvgTmp =  toSend[@"revenge"];
    
    NSMutableArray* theirRevenge = [NSMutableArray arrayWithArray:theirRvgTmp];
    
//    for (PFUser* usr in theirRevenge) {
//        [usr fetchIfNeeded];
//    }
    
    if(theirRevenge.count == 5)
    {
        if([theirRevenge containsObject:[PFUser currentUser].objectId])
        {
            [theirRevenge removeObject:[PFUser currentUser].objectId];
        }
        else
        {
            [theirRevenge removeLastObject];
        }
        
        [theirRevenge insertObject:[PFUser currentUser].objectId atIndex:0];
    }
    else
    {
        if([theirRevenge containsObject:[PFUser currentUser].objectId])
        {
            [theirRevenge removeObject:[PFUser currentUser].objectId];
        }
        
        [theirRevenge insertObject:[PFUser currentUser].objectId atIndex:0];
    }

    [toSend saveInBackground];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _revengeIds.count;
            break;
        case 1:
            return _recentIds.count;
            break;
        case 2:
            return _friends.count;
            break;
    }
    return -1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend"];
    
    if(!cell)
    {
        cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friend"];
    }
    
    NSArray* arr;
    
    switch (indexPath.section) {
        case 0:
            arr = _revengeIds;
            break;
        case 1:
            arr = _recentIds;
            break;
        case 2:
            arr = _friends;
            break;
    }
    
    /** Friends doesnt store ids but the others do*/
    if([arr isEqualToArray:_friends])
    {
        [((FriendTableViewCell *)cell) setUser:arr[indexPath.row]];
    }
    else
    {
        [((FriendTableViewCell *)cell) setUserId:arr[indexPath.row]];
    }
    return cell;
}

@end
