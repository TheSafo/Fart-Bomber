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
        _friends = [NSMutableArray array];
        _recent = [NSMutableArray array];
        _revenge = [NSMutableArray array];
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
    

    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if(!_shouldntUseThis)
    {
        [self.navigationController pushViewController: [[FBLoginController alloc] init] animated:YES];
    }
    else{
        //Normal viewDidAppear
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser* toSend = _friends[indexPath.row];
    
    PFQuery *qry = [PFInstallation query];
    [qry whereKey:@"user" equalTo:toSend];
    //Brendan is the best!
    
    PFPush *push = [[PFPush alloc] init];

    [push setQuery:qry];
    NSDictionary *data = @{
        @"alert" : @"FART BOMBED",
        @"sound" : @"fart1.caf",
    };
    [push setData:data];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"push error %@", error);
    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            return _revenge.count;
//            break;
//        case 1:
//            return _recent.count;
//            break;
//        case 2:
//            return _friends.count;
//        default:
//            return 0;
//            break;
//    }
    
    return _friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend"];
    
    if(!cell)
    {
        cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friend"];
    }
    
    PFUser* temp;
    NSArray* arr;
//    
//    switch (indexPath.section) {
//        case 0:
//            arr = _revenge;
//            break;
//        case 1:
//            arr = _recent;
//            break;
//        case 2:
//            arr = _friends;
//            break;
//    }
//
    arr = _friends;

    
    temp = arr[indexPath.row];

    [((FriendTableViewCell *)cell) setUser:temp];
    return cell;
}

@end
