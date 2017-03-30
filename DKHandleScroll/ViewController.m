//
//  ViewController.m
//  DKHandleScroll
//
//  Created by Darshan Karekar on 30/03/17.
//  Copyright © 2017 SuryaInovations. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
   }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    // Just Add instance of scrollView
    [[DKHandleScroll sharedInstance] makeScrollable:_mainScroll];

    
}
#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
}

@end
