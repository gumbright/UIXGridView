//
//  gridlinesViewController.m
//  gridlines
//
//  Created by gumbright on 11/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "gridlinesViewController.h"
#import "UIXGridView.h"

@implementation gridlinesViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (void)viewDidLoad 
{
    [super viewDidLoad];

	grid = [[UIXGridView alloc] initWithFrame:CGRectMake(0,0,320,460) andStyle:UIXGridViewStyle_Constrained selectionType:UIXGridViewSelectionType_Momentary];
//	grid = [[UIXGridView alloc] initWithFrame:CGRectMake(0,0,320,460) andStyle:UIXGridViewStyle_Constrained selectionType:UIXGridViewSelectionType_Single];
	
	grid.horizontalGridLineWidth = 5;
	grid.verticalGridLineWidth = 5;
	grid.borderGridLineWidth = 5;
	grid.gridLineColor = [UIColor whiteColor];
	grid.selectionColor = [UIColor redColor];
	grid.dataSource = self;
	grid.delegate = self;
	
	[self.view addSubview:grid];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (void)dealloc 
{
    [super dealloc];
}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (UIXGridViewCell*) UIXGridView:(UIXGridView*) gridView cellForIndexPath:(NSIndexPath*) indexPath
{
	UIXGridViewCell* cell = [gridView dequeueReusableCellWithIdentifier:@"gridlines"];
	if (cell == nil)
	{
		cell = [[UIXGridViewCell alloc] initWithStyle:UIXGridViewCellStyleDefault reuseIdentifier:@"gridlines"];
	}
	
	//cell.contentView.backgroundColor = [UIColor purpleColor];
	return cell;
}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (NSInteger) numberOfColumnsForGrid:(UIXGridView*) grid
{
	return 2;
}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (NSInteger) numberOfRowsForGrid: (UIXGridView*) grid
{
	return 3;
}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (UIXGridViewCellSelectionStyle) UIXGridView: (UIXGridView*) gridView  selectionStyleForCellAtIndexPath:(NSIndexPath*) indexPath
{
	return UIXGridViewCellSelectionStyleRoundRect;
}

@end
