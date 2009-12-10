//
//  FancySelectViewController.m
//  FancySelect
//
//  Created by gumbright on 8/24/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FancySelectViewController.h"
#import "FancySelectCell.h"

@implementation FancySelectViewController



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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	CGRect frame = CGRectMake(0,0,320,460);
	gridView =[[UIXGridView alloc] initWithFrame:frame 
										andStyle:UIXGridViewStyle_Constrained 
								   selectionType: UIXGridViewSelectionType_Momentary];
	gridView.delegate = self;
	gridView.dataSource = self;
	gridView.backgroundColor = [UIColor clearColor];
	gridView.customSelect = YES;
	UIColor* selectColor = [[UIColor alloc] initWithWhite:1.0 alpha:0.75];

	gridView.selectionColor = selectColor;
	self.title = @"FancySelect";
	[self.view addSubview:gridView];
	
	
	labels = [NSArray arrayWithObjects: [NSArray arrayWithObjects:@"one",@"two",nil],
			        [NSArray arrayWithObjects:@"three",@"four",nil],nil];
	
	onImage = [[UIImage imageNamed:@"Subscribe-On.png"] retain];
	offImage = [[UIImage imageNamed:@"llama.png"] retain];
//	offImage = [[UIImage imageNamed:@"Subscribe-Off.png"] retain];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


///////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////
- (UIXGridViewCell*) UIXGridView:(UIXGridView*) theGridView cellForIndexPath:(NSIndexPath*) indexPath
{
	FancySelectCell* cell;
	cell = (FancySelectCell*) [theGridView dequeueReusableCellWithIdentifier:@"fancycell"];
	if (cell == nil)
	{
		cell = [[FancySelectCell alloc] initWithReuseIdentifier:@"fancycell" ];
	}
	
	cell.cellLabel.text = @"Blah";
	cell.onImage = onImage;
	cell.offImage = offImage;
	
	return cell;
}

///////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////
- (NSInteger) numberOfColumnsForGrid:(UIXGridView*) grid
{
	return 2;
}

///////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////
- (NSInteger) numberOfRowsForGrid: (UIXGridView*) grid
{
	return 2;
}

///////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////
//- (NSInteger) cellHeightForGrid:(UIXGridView*) grid
//{
//	return 80;
//}

///////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////
- (void) UIXGridView: (UIXGridView*) gridView  didSelectCellForIndexPath:(NSIndexPath*) indexPath
{
	
}

@end
