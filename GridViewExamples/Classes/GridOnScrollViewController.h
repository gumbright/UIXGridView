//
//  GridOnScrollViewController.h
//  GridViewExamples
//
//  Created by gumbright on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIXGridView;

@interface GridOnScrollViewController : UIViewController 
{
	IBOutlet UIView* gridContainer;
	IBOutlet UIScrollView* scroll;
	IBOutlet UITableView* table;
	
	UIXGridView* grid;
}

@end
