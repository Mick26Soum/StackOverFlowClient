//
//  MyProfileJSONParser.m
//  StackOverflow
//
//  Created by MICK SOUMPHONPHAKDY on 10/5/15.
//  Copyright © 2015 MICK SOUMPHONPHAKDY. All rights reserved.
//

#import "MyProfileJSONParser.h"
#import "MyProfile.h"

@implementation MyProfileJSONParser

+(NSArray *)myProfileResultsFromJSON:(NSDictionary *)jsonInfo{
  
  //Array to store myProfile info
  NSMutableArray *myProfileInfo = [[NSMutableArray alloc]init];
  
  // Access the items array
  NSArray *items = jsonInfo[@"items"];
  
  //Parse items dictionary
  for (NSDictionary *item in items) {
    MyProfile *myProfile = [[MyProfile alloc] init];
    NSDictionary *owner = item[@"owner"];
    myProfile.userName = owner[@"display_name"];
    myProfile.avatarURL = owner[@"profile_image"];
    myProfile.reputation = owner[@"reputation"];
    [myProfileInfo addObject:myProfile];
    
  }
  return myProfileInfo;
}

@end
