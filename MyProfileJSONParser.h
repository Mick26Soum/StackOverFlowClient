//
//  MyProfileJSONParser.h
//  StackOverflow
//
//  Created by MICK SOUMPHONPHAKDY on 10/5/15.
//  Copyright © 2015 MICK SOUMPHONPHAKDY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyProfileJSONParser : NSObject

+(NSArray *)myProfileResultsFromJSON:(NSDictionary *)jsonInfo;

@end
