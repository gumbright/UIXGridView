//
//  gridlinesAppDelegate.m
//  gridlines
//
//  Created by gumbright on 11/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "gridlinesAppDelegate.h"
#import "gridlinesViewController.h"

@implementation gridlinesAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
