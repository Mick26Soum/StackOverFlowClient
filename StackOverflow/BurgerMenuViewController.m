//
//  BurgerMenuViewController.m
//  StackOverflow
//
//  Created by MICK SOUMPHONPHAKDY on 9/14/15.
//  Copyright (c) 2015 MICK SOUMPHONPHAKDY. All rights reserved.
//

#import "BurgerMenuViewController.h"
#import "QuestionSearchViewController.h"
#import "MyQuestionsViewController.h"
#import "MyProfileViewController.h"
#import "WebViewController.h"
#import "Errors.h"

CGFloat const kburgerOpenScreenDivider = 3.0;
CGFloat const kburgerOpenScreenMultiplier = 2.0;
NSTimeInterval const ktimeToSlideMenuOpen = 0.3;
CGFloat const kburgerButtonWidth = 50.0;
CGFloat const kburgerButtonHeight = 50.0;

@interface BurgerMenuViewController () <UITableViewDelegate>

@property (strong, nonatomic) UIViewController *topViewController; // current VC set on BurgerMenu
@property (strong, nonatomic) UIButton *burgerButton;
@property (strong, nonatomic) NSArray *childViewControllers;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation BurgerMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  UITableViewController *mainMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
  mainMenuVC.tableView.delegate = self;
  [self addChildViewController:mainMenuVC];
  mainMenuVC.view.frame = self.view.frame; // Otherwise the frame will be 0,0,0,0 = it won't show up
  [self.view addSubview:mainMenuVC.view];
  [mainMenuVC didMoveToParentViewController:self];
  
  // Child Content View Controllers Array Setup
  QuestionSearchViewController *questionSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionSearch"];
  [self addChildViewController:questionSearchVC];
  questionSearchVC.view.frame = self.view.frame;
  [self.view addSubview:questionSearchVC.view];
  [questionSearchVC didMoveToParentViewController:self];
  
  MyQuestionsViewController *myQuestionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyQuestions"];
  [self addChildViewController:myQuestionVC];
  
  MyProfileViewController *myProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfile"];
  [self addChildViewController:myProfileVC];
  
  
  self.childViewControllers = @[questionSearchVC, myQuestionVC, myProfileVC];
  self.topViewController = questionSearchVC;
  
  // Burger Button Icon Set Up
  self.burgerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kburgerButtonWidth, kburgerButtonHeight)];
  [self.burgerButton setImage:[UIImage imageNamed:@"burger"] forState:UIControlStateNormal];
  [self.topViewController.view addSubview:self.burgerButton];
  [self.burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  
  // Pan Gesture Initialize
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(topViewControllerPanned:)];
  // Add Gesture to topVC, this will trigger everytime pan is activated on topVC
  [self.topViewController.view addGestureRecognizer:pan];
  self.pan = pan;
  
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  // if StackOverFlow token exists, do not display the sign on page
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [defaults objectForKey:@"oAuthToken"];
  
  if (!token) {
    WebViewController *webVC = [[WebViewController alloc]init];
    [self presentViewController:webVC animated:true completion:nil];
  }
}

#pragma mark - BurgerButtonPressed Method
- (void)burgerButtonPressed:(UIButton*)sender{

  [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
    self.topViewController.view.center = CGPointMake(self.view.center.x *kburgerOpenScreenMultiplier, self.topViewController.view.center.y);
  } completion:^(BOOL finished) {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToCloseMenu:)];
    [self.topViewController.view addGestureRecognizer:tap];
    sender.userInteractionEnabled = false; // disable button
    
  }];

}

#pragma mark - PanGesture Method

- (void)topViewControllerPanned:(UIPanGestureRecognizer*)sender{
  
  //set up velocity and translation
  CGPoint velocity = [sender velocityInView:self.topViewController.view];
  CGPoint translation = [sender translationInView:self.topViewController.view];
  
  // move topVC to the right
  if (sender.state == UIGestureRecognizerStateChanged) {
    if (velocity.x > 0) { //means it moving to the right if velocity is greater then 0
      self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translation.x, self.topViewController.view.center.y);
      [sender setTranslation:CGPointZero inView:self.topViewController.view]; // prevents shift of VC from going offscreen
    }
  }
  
  // check to see when user lets go of gesture then then open
  if (sender.state == UIGestureRecognizerStateEnded) {
  
    // figure out if they mean to open it or close, // check if moved a 3rd of screen = meant to open
    if (self.topViewController.view.frame.origin.x > self.topViewController.view.frame.size.width/kburgerOpenScreenDivider) {
      [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x *kburgerOpenScreenMultiplier, self.topViewController.view.center.y);
      } completion:^(BOOL finished) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToCloseMenu:)];
        [self.topViewController.view addGestureRecognizer:tap];
        self.burgerButton.userInteractionEnabled = false;
      
      }];
    }else{
      [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x, self.topViewController.view.center.y);
      } completion:^(BOOL finished) {
        
      }];
    }
  }
}

- (void)tapToCloseMenu:(UITapGestureRecognizer *)tap{
  [self.topViewController.view removeGestureRecognizer:tap]; // remove when detected
  
  [UIView animateWithDuration:0.3 animations:^{
    self.topViewController.view.center = self.view.center;
  } completion:^(BOOL finished) {
    self.burgerButton.userInteractionEnabled = true;
  }];
}

#pragma mark - switchToVC method
- (void)switchToViewController:(UIViewController*)newVC{
  //animate old childVC offscreen
  [UIView animateWithDuration:0.3 animations:^{
  
    self.topViewController.view.frame = CGRectMake(self.view.frame.size.width, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
    
  } completion:^(BOOL finished) {
  
    CGRect oldFrame = self.topViewController.view.frame;
    
    //remove childVC from screen
    [self.topViewController willMoveToParentViewController:nil];
    [self.topViewController.view removeFromSuperview];
    [self.topViewController removeFromParentViewController];
    
    //add new childVC to screen
    [self addChildViewController:newVC];
    newVC.view.frame = oldFrame;
    [self.view addSubview:newVC.view];
    [newVC didMoveToParentViewController:self];
    self.topViewController = newVC;
    
    //burgerButton setup
    [self.burgerButton removeFromSuperview];
    [self.topViewController.view addSubview:self.burgerButton];
    
    //animate new childVC onscreen
    [UIView animateWithDuration:0.3 animations:^{
      self.topViewController.view.center = self.view.center;
    } completion:^(BOOL finished) {
      [self.topViewController.view addGestureRecognizer:self.pan];
      self.burgerButton.userInteractionEnabled = true;
    }];

  }];
  
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NSLog(@"%ld", (long)indexPath.row);
  
  UIViewController *changeToVC = self.childViewControllers[indexPath.row];
  if (![changeToVC isEqual:self.topViewController]) {
    [self switchToViewController:changeToVC];
  }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
