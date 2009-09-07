//
//  GridViewExamplesAppDelegate.h
//  GridViewExamples
//
//  Created by gumbright on 8/17/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@interface GridViewExamplesAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

