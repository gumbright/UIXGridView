    //
//  SpanningViewController.m
//  GridViewExamples
//
//  Created by gumbright on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpanningViewController.h"
#import "UIXGridViewSpanningCell.h"

@implementation SpanningViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

////////////////////////////////////////////////
//
////////////////////////////////////////////////
- (void)loadView 
{
	CGRect frame = CGRectMake(0,0,320,416);
	UIView* view = [[UIView alloc] initWithFrame:frame];
	self.view = view;
	//	UIXGridView* gv = [[UIXGridView alloc] initWithFrame:frame andStyle:UIXGridViewStyle_Constrained selectionType: UIXGridViewSelectionType_Momentary];
	grid = [[UIXGridView alloc] initWithFrame:frame andStyle:UIXGridViewStyle_VertConstrained];
	
	grid.gridDelegate = self;
	grid.dataSource = self;
	
	grid.backgroundColor = [UIColor whiteColor];
	grid.selectionColor = [UIColor redColor];
	
	grid.verticalGridLineWidth = 10;
	grid.horizontalGridLineWidth = 10;
	grid.gridLineColor = [UIColor purpleColor];
	
	self.title = @"Spanning";
	[view addSubview:grid];
	[grid release];
	
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
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark UIXGridView delegate & datasource
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
	return 4;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (NSInteger) cellWidthForGrid:(UIXGridView*) grid
{
	return 104;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (UIXGridViewSpanningCell*) allocSpanningCellForGrid:(UIXGridView*) gridView
{
	UIXGridViewSpanningCell* cell = [gridView dequeueReusableCellWithIdentifier:@"spanning"];
	if (cell == nil)
	{
		cell = [[UIXGridViewSpanningCell alloc] initWithStyle:UIXGridViewCellStyleDefault 
											  reuseIdentifier:@"spanning"
												 widthInCells:2 
												heightInCells:2];
		UIImageView* v = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
		v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		v.image = [UIImage imageNamed:@"album9e.jpg"];
		[cell.contentView addSubview:v];
//		v.backgroundColor = [UIColor greenColor];
		[v release];
	}
	
	return cell;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (UIXGridViewCell*) UIXGridView:(UIXGridView*) gridView cellForIndexPath:(NSIndexPath*) indexPath
{
	UIXGridViewCell* cell;
	
	if ([indexPath row] == 1 && [indexPath column] == 1)
	{
		cell = [self allocSpanningCellForGrid:gridView];
	}
	else if (([indexPath row] == 1 && [indexPath column] == 2) ||
		([indexPath row] == 2 && [indexPath column] == 1) ||
		([indexPath row] == 2 && [indexPath column] == 2))
	{
		cell = [[UIXGridViewSpannedCell alloc] init];
	}
	else 
	{
		cell = [gridView dequeueReusableCellWithIdentifier:@"Nonspanning"];
		if (cell == nil)
		{
			cell = [[[UIXGridViewCell alloc] initWithStyle:UIXGridViewCellStyleDefault reuseIdentifier:@"Nonspanning"] autorelease];
			
		}
		
		int ndx = [indexPath row] + [indexPath column];
		if (ndx >=9) ndx -= 9;
		
		NSArray* arr = [planetData objectAtIndex:ndx];
		cell.textLabel.text = [arr objectAtIndex:0];
		cell.imageView.image = [arr objectAtIndex: 1];
	}

	return cell;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (UIXGridViewSpanningCell*) UIXGridView:(UIXGridView*) gridView spanningCellAtIndex:(NSIndexPath**) spanningCellIndex forSpannedCellAt:(NSIndexPath*) indexPath
{
	UIXGridViewSpanningCell* cell = nil;
	
	if (([indexPath row] == 1 && [indexPath column] == 2) ||
			 ([indexPath row] == 2 && [indexPath column] == 1) ||
			 ([indexPath row] == 2 && [indexPath column] == 2))
	{
		cell = [self allocSpanningCellForGrid:gridView];
		*spanningCellIndex = [NSIndexPath indexPathForColumn:1 row:1];
	}
	
	return cell;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
//- (NSInteger) cellHeightForGrid:(UIXGridView*) grid
//{
//	return 100;
//}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
//- (void) UIXGridView: (UIXGridView*) gridView  willSelectCellAtIndexPath:(NSIndexPath*) indexPath
//{
//	NSLog(@"hit willSelectCellAtIndexPath");
//}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
//- (void) UIXGridView: (UIXGridView*) gridView  didSelectCellAtIndexPath:(NSIndexPath*) indexPath
//{
//	UIAlertView* v = [[[UIAlertView alloc] initWithTitle:@"You picked" 
//												 message:@"something"
//												delegate:nil 
//									   cancelButtonTitle:@"Why yes I did!" 
//									   otherButtonTitles:nil] autorelease];
//	[v show];
//	[gridView deselectCellAtIndexPath:indexPath animated:YES];
//}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
//- (BOOL) UIXGridView: (UIXGridView*) gridView  shouldSelectCellAtIndexPath:(NSIndexPath*) indexPath
//{
//	return YES;
//}

@end
