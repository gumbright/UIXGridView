//
//  gridlinesAppDelegate.h
//  gridlines
//
//  Created by gumbright on 11/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class gridlinesViewController;

@interface gridlinesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    gridlinesViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet gridlinesViewController *viewController;

@end

