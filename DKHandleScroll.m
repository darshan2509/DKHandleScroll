//
//  HandleScroll.m
//
//
//  Created by Darshan Karekar on 17/01/17.
//  Copyright © 2017 Darshan. All rights reserved.
//

#import "DKHandleScroll.h"

@implementation DKHandleScroll
static DKHandleScroll* _handleScroll = nil;

+(DKHandleScroll*) sharedInstance{
    @synchronized ([DKHandleScroll class]) {
        if (!_handleScroll)
        {
           DKHandleScroll *k = [[self alloc] init];
       // NSLog(@"%@",k.description);
        }
        return _handleScroll;
    }
    return nil;
}

+(instancetype)alloc{
    @synchronized ([DKHandleScroll class]) {
        _handleScroll = [super alloc];
        return _handleScroll;
    }
    return nil;
}

-(instancetype)init{
    self = [super init];
    if (self != nil){
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _rootVC = appDelegate.window.rootViewController;
    }
    return self;
}

#pragma mark - ScrollView Delegates
- (void)keyboardWasShown:(NSNotification*)notification :(UIScrollView *)mainScroll :(UIViewController *)VC :(CGRect )TXFRAME
{
    _reset = [mainScroll contentOffset];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ) {
        CGSize origKeySize = keyboardSize;
        keyboardSize.height = origKeySize.width;
        keyboardSize.width = origKeySize.height;
    }
    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    
    //NSLog(@"hei %f wi %f",kbSize.height,kbSize.width);
    
    CGSize deviceSize=[UIScreen mainScreen].bounds.size;
    float keyBdHeight;
    
    if (kbSize.height<kbSize.width)
    {
        
        keyBdHeight=kbSize.height;
        
    }
    else
    {
        keyBdHeight=kbSize.width;
        
    }
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(00.0, 0.0,keyBdHeight, 0.0);
    
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    CGRect aRect = VC.view.frame;
    aRect.size.height -= keyBdHeight;
    
    
    
    TXFRAME.origin.y = TXFRAME.origin.y+TXFRAME.size.height+20;
    
    if (!CGRectContainsPoint(aRect, TXFRAME.origin) ) {
        CGPoint scrollPoint =CGPointMake(0.0,ABS(TXFRAME.origin.y+20-(deviceSize.height-keyBdHeight+22)));
        [mainScroll setContentOffset:scrollPoint animated:YES];
        
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification :(UIScrollView *)mainScroll
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0 ,0, 0, 0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    [mainScroll setContentOffset:_reset animated:YES];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
- (CGRect) convertView:(UIView*)view
{
    CGRect rect = view.frame;
    while(view.superview)
    {
        view = view.superview;
        rect.origin.x += view.frame.origin.x;
        rect.origin.y += view.frame.origin.y;
    }
    return rect;
    
}



-(void)registerForNotification :(UIViewController *)currentVC
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWasShown:(NSNotification *)notification
{
    
    id k = [UIResponder currentFirstResponder];
    if(([k isKindOfClass:[UITextField class]])||([k isKindOfClass:[UITextView class]]))
    {
    UIView *textview = (UIView *)k;
    CGRect TXFRAME = [self convertView:textview];
    [self keyboardWasShown:notification :_scrollView :_currentViewController :TXFRAME];
    }
}

-(void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self keyboardWillBeHidden:notification :_scrollView];
}

-(void)makeScrollable:(UIScrollView *)scrollView
{
    [self setCurrentViewController:[self findTopVC]];
    [self setScrollView:scrollView];
    [self registerForNotification:_currentViewController];
}

-(UIViewController *)findTopVC
{
    UIViewController *top = nil;
    
    if(_rootVC.navigationController !=nil)
    {
        top = _rootVC.navigationController.topViewController;
    }
    else if(_rootVC.tabBarController != nil){
        top = _rootVC.tabBarController.selectedViewController;
    }
    else{
        UIViewController *parentViewController = _rootVC;
        while (parentViewController.presentedViewController != nil){
            parentViewController = parentViewController.presentedViewController;
        }
        top = parentViewController;
    }
    
  //  NSLog(@"Curent Top VC: %@", top.description);
    return top;
}
@end
