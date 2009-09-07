//
//  FancySelectAppDelegate.h
//  FancySelect
//
//  Created by gumbright on 8/24/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FancySelectViewController;

@interface FancySelectAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FancySelectViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FancySelectViewController *viewController;

@end

