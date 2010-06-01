//
//  VertConstrainedSingleSelectViewController.h
//  GridViewExamples
//
//  Created by gumbright on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
////////////////////////////////////////////////////
//
// demonstrates a custom color selection and an overlay view
//
////////////////////////////////////////////////////

@interface VertConstrainedSingleSelectViewController : UIViewController 
{
	NSIndexPath* currentSelection;
	UIView* overlay;
}

@property (nonatomic, retain) NSIndexPath* currentSelection;
@property (assign) UIView* overlay;
@end
