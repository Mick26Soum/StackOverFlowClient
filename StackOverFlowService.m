//
//  StackOverFlowService.m
//  StackOverflow
//
//  Created by MICK SOUMPHONPHAKDY on 10/4/15.
//  Copyright © 2015 MICK SOUMPHONPHAKDY. All rights reserved.
//

#import "StackOverFlowService.h"
#import <AFNetworking/AFNetworking.h>
#import "Errors.h"
#import "QuestionJSONParser.h"
#import "MyProfileJSONParser.h"

@implementation StackOverFlowService

+ (void)questionsForSearchTerms:(NSString*)searchTerm
completionHandler:(void(^)(NSArray *, NSError *))completionHandler{

   NSString *url = @"https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=swift&site=stackoverflow";

//    NSString *baseurl = @"https://api.stackexchange.com/2.2/search?";
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [userDefaults objectForKey:@"oAuthToken"];
//    //a9yMN6fPa8C64V(tYgewEA))
//    NSLog(@"%@", token);
//    NSString *key = @")i11gHfalj0Abty9BncVSg((";
//    NSLog(@"%@", searchTerm);
//    NSLog(@"%@", key);
//    NSString *url = [NSString stringWithFormat:@"%@access_token=%@&key=%@&order=desc&sort=activity&intitle=%@&site=stackoverflow",baseurl, token, key, searchTerm];
  
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
 [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
   NSLog(@"%ld", operation.response.statusCode);
   NSLog(@"%@", responseObject);
  
   NSArray *questions = [QuestionJSONParser questionsResultsFromJSON:responseObject];
   
   completionHandler(questions,nil);
   
 } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
   if (operation.response) {
     
     NSError *stackOverFlowError = [self errorForStatusCode:operation.response.statusCode];
     completionHandler(nil,stackOverFlowError);
     dispatch_async(dispatch_get_main_queue(), ^{
       completionHandler(nil, stackOverFlowError);
     });
    
   }else{
   
     NSError *reachabilityError = [self checkReachability];
     if (reachabilityError) {
       completionHandler(nil, reachabilityError);
     }
     
   }
 }];
 
}

+ (void)retrieveUserProfile:(void(^)(NSArray *, NSError *))completionHandler{
  
  NSString *baseurl = @"https://api.stackexchange.com/2.2/me?order=desc&sort=reputation&site=stackoverflow";
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [userDefaults objectForKey:@"oAuthToken"];
  NSString *key = @")i11gHfalj0Abty9BncVSg((";
  NSString *url = [NSString stringWithFormat:@"%@&access_token=%@&key=%@",baseurl, token, key];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * operation, id responseObject) {
    NSArray *profile = [MyProfileJSONParser myProfileResultsFromJSON:responseObject];
    
    completionHandler(profile, nil);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if(operation.response) {
    
      NSError *stackOverFlowError = [self errorForStatusCode:operation.response.statusCode];
      dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(nil,stackOverFlowError);
      });
    } else {
      NSError *reachabilityError = [self checkReachability];
      if (reachabilityError) {
      
        completionHandler(nil, reachabilityError);
        
      }
    }
  }];
}

+(NSError *)checkReachability{
  if (![AFNetworkReachabilityManager sharedManager].reachable) {
    NSError *error = [NSError errorWithDomain:kStackOverFlowErrorDomain code:StackOverFlowConnectionDown userInfo:@{NSLocalizedDescriptionKey : @"Could not connect to servers, please try again when you have a connections"}];
    return error;
  }
  return  nil;
}

+ (NSError *)errorForStatusCode:(NSInteger)statusCode{
  
  NSInteger errorCode;
  NSString *localizedDescription;
  
  switch (statusCode) {
    case 502:
      localizedDescription = @"There are too many request, please slow down.";
      errorCode = StackOverFlowTooManyAttempts;
      break;
    case 400:
      localizedDescription = @"Invalid Entry, please try another search term";
      errorCode = StackOverFlowInvalidParameter;
      break;
    case 401:
      localizedDescription = @"Access has been denied, please sign in.";
      errorCode = StackOverFlowAuthenticationRequired;
      break;
    default:
      localizedDescription = @"Could not complete operation, please try again later";
      errorCode = StackOverFlowDefaultError;
      break;
  }
  
  NSError *error = [NSError errorWithDomain:kStackOverFlowErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey : localizedDescription}];
  return error;
  
}

@end
