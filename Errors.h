//
//  Errors.h
//  StackOverflow
//
//  Created by MICK SOUMPHONPHAKDY on 10/4/15.
//  Copyright © 2015 MICK SOUMPHONPHAKDY. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kStackOverFlowErrorDomain;

typedef enum : NSUInteger {
  StackOverFlowBadJSON = 200,
  StackOverFlowConnectionDown,
  StackOverFlowTooManyAttempts,
  StackOverFlowInvalidParameter,
  StackOverFlowAuthenticationRequired,
  StackOverFlowDefaultError
} StackOverFlowErrorCodes;