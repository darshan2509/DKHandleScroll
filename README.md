# DKHandleScroll
DKHandleScroll keeps track of the keyboard frame, and lets you manage your scroll view insets along with custom views' frames the easy way, handling animations completely transparently for you. It will also help you scrolling down your scroll views with the keyboard when appropriate.

// Just add these files
1. DKHandleScroll.h
2. DKHandleScroll.m
3. UIResponder+FirstResponder.h
4. UIResponder+FirstResponder.m


// Add the following code in viewWillAppear

-(void)viewWillAppear:(BOOL)animated
{

    // Just Add instance of scrollView
    
    [[DKHandleScroll sharedInstance] makeScrollable:_mainScroll];


    
}
