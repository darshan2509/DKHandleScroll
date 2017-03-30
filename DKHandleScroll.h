//
//  HandleScroll.m
//
//
//  Created by Darshan Karekar on 17/01/17.
//  Copyright © 2017 Darshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIResponder+FirstResponder.h"
#import "AppDelegate.h"

@interface DKHandleScroll : NSObject
@property UIViewController *rootVC;

@property CGPoint reset;

//set below properties
@property UIScrollView *scrollView;
@property UIViewController *currentViewController;
//

+ (instancetype) sharedInstance;
- (void)keyboardWasShown:(NSNotification*)notification :(UIScrollView *)mainScroll :(UIViewController *)VC :(CGRect )TXFRAME;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification :(UIScrollView *)mainScroll;
- (CGRect) convertView:(UIView*)view;
-(void)registerForNotification :(UIViewController *)currentVC;
-(void)makeScrollable:(UIScrollView *)scrollView;
@end
