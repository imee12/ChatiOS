//
//  EditFriendsViewController.h
//  Ribbit
//
//  Created by Imee Cuison on 6/4/15.
//  Copyright (c) 2015 Imee Cuison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditFriendsViewController : UITableViewController

@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSMutableArray *friends;


-(BOOL)isFriend:(PFUser *)user;
@end
