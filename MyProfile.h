//
//  MyProfile.h
//  StackOverflow
//
//  Created by MICK SOUMPHONPHAKDY on 10/5/15.
//  Copyright © 2015 MICK SOUMPHONPHAKDY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyProfile : NSObject

@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *ownerLink;
@property (strong, nonatomic) NSNumber *reputation;

@end
