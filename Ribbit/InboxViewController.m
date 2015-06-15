//
//  InboxViewController.m
//  Ribbit
//
//  Created by Imee Cuison on 6/3/15.
//  Copyright (c) 2015 Imee Cuison. All rights reserved.
//

#import "InboxViewController.h"
#import "ImageViewController.h"
#import <Parse/Parse.h>


@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moviePlayer = [[MPMoviePlayerController alloc] init];
    
    PFUser *currentUser =[PFUser currentUser];
    if (currentUser) {
        
        NSLog(@"Current user: %@", currentUser.username);
        
    }
    else {
    
    [self performSegueWithIdentifier:@"showLogin" sender:self];
   
}
}

//GET MESSAGES SENT TO CURRENTUSER
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
    
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser) {
        PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
            NSLog(@"%@", [[PFUser currentUser] objectId]);
            [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
              //run query here
              
            [query orderByDescending:@"createdAt"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                if (error) {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
                else {
            //we found messages!
            self.messages = objects;
                    NSLog(@"Messages: %@", self.messages);
            [self.tableView reloadData];
            //NSLog(@"Retrieved %lu messages", (unsigned long)[self.messages count]);
        }
        
    }];
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
         NSLog(@"User not logged in.");
    }
         }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath:indexPath];
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"senderName"];
    NSString *fileType = [message objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_image"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"icon_video"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"]) {
        [self performSegueWithIdentifier:@"showimage" sender:self];
    }
    else {
       //when filetype is video
        PFFile *videoFile = [self.selectedMessage objectForKey: @"file"];
        NSURL *fileURL = [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL = fileURL;
        [self.moviePlayer prepareToPlay];
       // [self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        
        // add it to view controller
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    // delete it
    NSMutableArray *recipientIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientIds"]];
    NSLog(@"Recipients: %@", recipientIds);
    
    if ([recipientIds count] == 1) {
        // Last recipient - delete!
        [self.selectedMessage deleteInBackground];
    }
    else {
        // Remove the recipient and save
        [recipientIds removeObject:[[PFUser currentUser] objectId]];
        [self.selectedMessage setObject:recipientIds forKey:@"recipientIds"];
        [self.selectedMessage saveInBackground];
    }

}


//
//    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
//    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
//    if ([fileType isEqualToString:@"image"]) {
//        [self performSegueWithIdentifier:@"showImage" sender:self];
//    }
//    else {
//        // File type is video
//        PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
//        NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
//        self.moviePlayer.contentURL = fileUrl;
//        [self.moviePlayer prepareToPlay];
//        [self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
//        
//        // Add it to the view controller so we can see it
//        [self.view addSubview:self.moviePlayer.view];
//        [self.moviePlayer setFullscreen:YES animated:YES];
//    }
//    
//    // Delete it!
//    NSMutableArray *recipentIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipentIds"]];
//    NSLog(@"Recipients: %@", recipentIds);
//    
//    if ([recipentIds count] == 1) {
//        // Last recipient - delete!
//        [self.selectedMessage deleteInBackground];
//    }
//    else {
//        // Remove the recipient and save
//        [recipientIds removeObject:[[PFUser currentUser] objectId]];
//        [self.selectedMessage setObject:recipientIds forKey:@"recipientIds"];
//        [self.selectedMessage saveInBackground];
//    }
//    
//}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logout:(id)sender {
    
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        
    }
    else if ([segue.identifier isEqualToString:@"showimage"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        ImageViewController *imageViewController = (ImageViewController *) segue.destinationViewController;
        imageViewController.message = self.selectedMessage;
        
        
    }
        
    
}


@end
