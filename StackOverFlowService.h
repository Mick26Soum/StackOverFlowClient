//
//  StackOverFlowService.h
//  StackOverflow
//
//  Created by MICK SOUMPHONPHAKDY on 10/4/15.
//  Copyright © 2015 MICK SOUMPHONPHAKDY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StackOverFlowService : NSObject

+ (void)questionsForSearchTerms:(NSString*)searchTerm completionHandler:(void(^)(NSArray *, NSError *))completionHandler;
+ (void)retrieveUserProfile:(void(^)(NSArray *, NSError *))completionHandler;

@end
