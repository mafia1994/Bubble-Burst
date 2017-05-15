//
//  ViewController.m
//  FishyModule
//
//  Created by Pranav on 01/07/16.
//  Copyright © 2016 Pranav. All rights reserved.
//

#import "ViewController.h"
#import "MainGameView.h"
#import "BubbleGameScoreBoardViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)displayScoreBoard{
    BubbleGameScoreBoardViewController *viewControl = [self.storyboard instantiateViewControllerWithIdentifier:@"BubbleGameScoreBoardViewController"];
    [self.navigationController pushViewController:viewControl animated:YES];
}
- (IBAction)playGameBtnClick:(id)sender {
    CGRect frame = [[UIScreen mainScreen]bounds];
    [self.view addSubview:[MainGameView startFishyGame:frame viewController:self]];
}

- (void)closeGame
{
    
}

- (void)fbButtonAction
{
    
}

- (void)twitterButtonAction
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
