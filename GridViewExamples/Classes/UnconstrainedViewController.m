//
//  UnconstrainedViewController.m
//  GridViewExamples
//
//  Created by gumbright on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UnconstrainedViewController.h"
#import "UIXGridView.h"
#import "UIXGridViewCell.h"

@implementation UnconstrainedViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	CGRect frame = CGRectMake(0,0,320,416);
	UIView* view = [[UIView alloc] initWithFrame:frame];
	self.view = view;
//	UIXGridView* gv = [[UIXGridView alloc] initWithFrame:frame andStyle:UIXGridViewStyle_Constrained selectionType: UIXGridViewSelectionType_Momentary];
	UIXGridView* gv = [[UIXGridView alloc] initWithFrame:frame andStyle:UIXGridViewStyle_Unconstrained];

	gv.gridDelegate = self;
	gv.dataSource = self;
	
	gv.backgroundColor = [UIColor whiteColor];
	gv.selectionColor = [UIColor redColor];
	
	self.title = @"Constrained Momentary";
	[view addSubview:gv];
	[gv release];
	
	planetData = [[NSArray arrayWithObjects:[NSArray arrayWithObjects:@"Mercury",[UIImage imageNamed:@"mercury.jpeg"] ,nil],
										[NSArray arrayWithObjects: @"Venus",[UIImage imageNamed:@"venus.jpeg"] ,nil],
										 [NSArray arrayWithObjects:@"Earth",[UIImage imageNamed:@"earth.jpeg"] ,nil],
										[NSArray arrayWithObjects:@"Mars",[UIImage imageNamed:@"mars.jpeg"] ,nil],
										[NSArray arrayWithObjects: @"Jupiter",[UIImage imageNamed:@"jupiter.jpeg"] ,nil],
										[NSArray arrayWithObjects: @"Saturn",[UIImage imageNamed:@"saturn.jpeg"] ,nil],
										[NSArray arrayWithObjects:@"Neptune",[UIImage imageNamed:@"neptune.jpeg"] ,nil],
										 [NSArray arrayWithObjects:@"Uranus",[UIImage imageNamed:@"uranus.jpeg"] ,nil],
										 [NSArray arrayWithObjects:@"Pluto",[UIImage imageNamed:@"pluto.jpeg"] ,nil],
			   nil] retain];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void)dealloc {
    [super dealloc];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (UIXGridViewCell*) UIXGridView:(UIXGridView*) gridView cellForIndexPath:(NSIndexPath*) indexPath
{
	UIXGridViewCell* cell;
	
	cell = [gridView dequeueReusableCellWithIdentifier:@"ConstrainedMomentaryCell"];
	if (cell == nil)
	{
		cell = [[[UIXGridViewCell alloc] initWithStyle:UIXGridViewCellStyleDefault reuseIdentifier:@"ConstrainedMomentaryCell"] autorelease];
	}

	int ndx = [indexPath row] + [indexPath column];
	if (ndx >=9) ndx -= 9;
	
	NSArray* arr = [planetData objectAtIndex:ndx];
	cell.textLabel.text = [arr objectAtIndex:0];
	cell.imageView.image = [arr objectAtIndex: 1];
	
	return cell;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (NSInteger) numberOfColumnsForGrid:(UIXGridView*) grid
{
	return 9;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (NSInteger) numberOfRowsForGrid: (UIXGridView*) grid
{
	return 9;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (NSInteger) cellWidthForGrid:(UIXGridView*) grid
{
	return 100;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (NSInteger) cellHeightForGrid:(UIXGridView*) grid
{
	return 100;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) UIXGridView: (UIXGridView*) gridView  willSelectCellAtIndexPath:(NSIndexPath*) indexPath
{
	NSLog(@"hit willSelectCellAtIndexPath");
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) UIXGridView: (UIXGridView*) gridView  didSelectCellAtIndexPath:(NSIndexPath*) indexPath
{
	UIAlertView* v = [[[UIAlertView alloc] initWithTitle:@"You picked" 
												 message:@"something"
												delegate:nil 
									   cancelButtonTitle:@"Why yes I did!" 
									   otherButtonTitles:nil] autorelease];
	[v show];
	[gridView deselectCellAtIndexPath:indexPath animated:YES];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (BOOL) UIXGridView: (UIXGridView*) gridView  shouldSelectCellAtIndexPath:(NSIndexPath*) indexPath
{
	return YES;
}

@end
