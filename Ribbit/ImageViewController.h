//
//  ImageViewController.h
//  Ribbit
//
//  Created by Imee Cuison on 6/15/15.
//  Copyright (c) 2015 Imee Cuison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong) PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

@end
