//
//  FancySelectAppDelegate.m
//  FancySelect
//
//  Created by gumbright on 8/24/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FancySelectAppDelegate.h"
#import "FancySelectViewController.h"

@implementation FancySelectAppDelegate

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
