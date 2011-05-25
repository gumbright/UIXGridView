//
//  CustomViewsController.h
//  GridViewExamples
//
//  Created by Guy Umbright on 5/21/11.
//  Copyright 2011 Kickstand Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIXGridView.h"


@interface CustomViewsController : UIViewController 
{
	UIXGridView* grid;
    
    NSMutableArray* contents;
}

@property (nonatomic, retain) IBOutlet UIView* gridContainer;

- (IBAction) plusPressed:(id) sender;
- (IBAction) minusPressed:(id) sender;

- (id) init;

@end
