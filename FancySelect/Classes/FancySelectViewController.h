//
//  FancySelectViewController.h
//  FancySelect
//
//  Created by gumbright on 8/24/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIXGridView.h"

@interface FancySelectViewController : UIViewController 
{
	UIXGridView* gridView;
	NSArray* labels;
	
	UIImage* onImage;
	UIImage* offImage;
}

@end

