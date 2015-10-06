//
//  QuestionSearchViewController.m
//  StackOverflow
//
//  Created by MICK SOUMPHONPHAKDY on 10/2/15.
//  Copyright © 2015 MICK SOUMPHONPHAKDY. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverFlowService.h"
#import "QuestionCell.h"
#import "Question.h"


@interface QuestionSearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *questions;

@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.searchBar.delegate = self;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
//  [self searchBarSearchButtonClicked:nil];
}

#pragma mark -- imageDownloader
- (void)imageDownloader {
  dispatch_group_t group = dispatch_group_create();
  dispatch_queue_t imageQueue = dispatch_queue_create("com.codefellows.stackoverflow",DISPATCH_QUEUE_CONCURRENT );
  
  for (Question *question in self.questions) {
    dispatch_group_async(group, imageQueue, ^{
      NSString *avatarURL = question.avatarURL;
      NSURL *imageURL = [NSURL URLWithString:avatarURL];
      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
      UIImage *image = [UIImage imageWithData:imageData];
      question.avatarImage = image;
    });
  }
  
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Images Downloaded" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      [alertController dismissViewControllerAnimated:true completion:nil];
    }];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:true completion:nil];
    self.isDownloading = false;
    [self.tableView reloadData];
  });
}

#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

  [StackOverFlowService questionsForSearchTerms:searchBar.text completionHandler:^(NSArray *results, NSError *error) {
    if (error) {
      
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:true completion:nil];
      }];
      
      [alertController addAction:action];
      
      [self presentViewController:alertController animated:true completion:nil];
      
    }else{
      self.questions = results;
      [self imageDownloader];
    }
  }];
  [self.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.questions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  QuestionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"QuestionCell" forIndexPath:indexPath];
  Question *question = self.questions[indexPath.row];
  cell.tag++;
  NSInteger tag = cell.tag;
  if (cell.tag == tag) {
    cell.avatarImage.image = question.avatarImage;
  }
  cell.nameLabel.text = question.ownerName;
  cell.questionLabel.text = question.title;
  return cell;
}



@end
