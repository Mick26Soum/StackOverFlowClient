//
//  MyProfileViewController.m
//  StackOverflow
//
//  Created by MICK SOUMPHONPHAKDY on 10/2/15.
//  Copyright © 2015 MICK SOUMPHONPHAKDY. All rights reserved.
//

#import "MyProfileViewController.h"
#import "StackOverFlowService.h"
#import "MyProfile.h"

@interface MyProfileViewController ()

@property (retain,nonatomic) NSString *myName;
@property (assign,nonatomic) NSNumber *myNumber;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) NSArray *profileArray;
@property (retain, nonatomic) MyProfile *myProfile;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//  NSString *myString = [[NSString stringWithFormat:@"Hi"] retain];
//  
//  self.myName = myString;
//  
//  self.myName = myString;
//  [myString release]; //down to 2
  
  
  [StackOverFlowService retrieveUserProfile:^(NSArray *results, NSError *error) {
    if (error) {
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:true completion:nil];
      }];
      [alertController addAction:action];
      
      [self presentViewController:alertController animated:true completion:nil];
    } else {
      self.profileArray = results;
      self.myProfile = self.profileArray.firstObject;
      self.userNameLabel.text = self.myProfile.userName;
      
      NSString *avatarURL = self.myProfile.avatarURL;
      NSURL *imageURL = [NSURL URLWithString:avatarURL];
      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
      UIImage *image = [UIImage imageWithData:imageData];
      self.myProfile.avatarImage = image;
      self.profileImage.image = self.myProfile.avatarImage;
    }
  }];
  
}

-(void)dealloc {
//  [_myName release];
  [_profileArray release];
  [_myProfile release];
  [super dealloc];
}


@end
