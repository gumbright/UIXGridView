//
//  VertConstrainedSingleSelectViewController.m
//  GridViewExamples
//
//  Created by gumbright on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "VertConstrainedSingleSelectViewController.h"
#import "UIXGridView.h"
#import "UIXGridViewCell.h"

@implementation VertConstrainedSingleSelectViewController

@synthesize currentSelection;
@synthesize overlay;
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
//	UIXGridView* gv =[[UIXGridView alloc] initWithFrame:frame andStyle:UIXGridViewStyle_VertConstrained selectionType: UIXGridViewSelectionType_Single];
	UIXGridView* gv =[[UIXGridView alloc] initWithFrame:frame andStyle:UIXGridViewStyle_VertConstrained];
	//gv.momentary = NO;
	//gv.multiSelect = NO;
	gv.gridDelegate = self;
	gv.dataSource = self;
	gv.backgroundColor = [UIColor whiteColor];
	gv.selectionColor = [UIColor redColor];
	self.title = @"Constrained Momentary";
//	[gv reloadData];
	[view addSubview:gv];
	[gv release];
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

- (UIXGridViewCell*) UIXGridView:(UIXGridView*) gridView cellForIndexPath:(NSIndexPath*) indexPath
{
	UIXGridViewCell* cell;
	
	NSLog(@"cell for %@ curSel = %@",indexPath,self.currentSelection);
	
	cell = [gridView dequeueReusableCellWithIdentifier:@"VertSingleCell"];
	if (cell == nil)
	{
		cell = [[[UIXGridViewCell alloc] initWithStyle:UIXGridViewCellStyleDefault reuseIdentifier:@"VertSingleCell"] autorelease];
	}
	else 
	{
		NSLog(@"reused cell %08X",cell);
	}

	switch (indexPath.row)
	{
		case 0:
		{
			switch (indexPath.column)
			{
				case 0:
				{
					cell.textLabel.text = @"Mercury";
					cell.imageView.image = [UIImage imageNamed:@"mercury.jpeg"];
				}
					break;
					
				case 1:
				{
					cell.textLabel.text = @"Venus";
					cell.imageView.image = [UIImage imageNamed:@"venus.jpeg"];
				}
					break;
					
				case 2:
				{
					cell.textLabel.text = @"Earth";
					cell.imageView.image = [UIImage imageNamed:@"earth.jpeg"];
				}
					break;
					
				case 3:
				{
					cell.textLabel.text = @"Mars";
					cell.imageView.image = [UIImage imageNamed:@"mars.jpeg"];
				}
					break;
					
				case 4:
				{
					cell.textLabel.text = @"Jupiter";
					cell.imageView.image = [UIImage imageNamed:@"jupiter.jpeg"];
				}
					break;
			}
		}
			break;
			
		case 1:
		{
			switch (indexPath.column)
			{
					
				case 0:
				{
					cell.textLabel.text = @"Saturn";
					NSLog(@"set saturn");
					cell.imageView.image = [UIImage imageNamed:@"saturn.jpeg"];
				}
					break;
					
				case 1:
				{
					cell.textLabel.text = @"Neptune";
					cell.imageView.image = [UIImage imageNamed:@"neptune.jpeg"];
				}
					break;
					
				case 2:
				{
					cell.textLabel.text = @"Uranus";
					cell.imageView.image = [UIImage imageNamed:@"uranus.jpeg"];
				}
					break;
					
				case 3:
				{
					cell.textLabel.text = @"Pluo";
					cell.imageView.image = [UIImage imageNamed:@"pluto.jpeg"];
				}
					break;
					
				default:
					cell = nil;
					break;
					
			}
		}
			break;
			
	}
	
//	if ([indexPath isEqual:self.currentSelection])
	if ([indexPath compare:self.currentSelection] == NSOrderedSame)
	{
//		NSLog(@"place overlay on %@",indexPath);
		CGRect frame = cell.contentView.frame;
		overlay.frame = frame;
		[cell setOverlayView:overlay];
	}
	
	return cell;
}

- (NSInteger) numberOfColumnsForGrid:(UIXGridView*) grid
{
	return 5;
}

- (NSInteger) numberOfRowsForGrid: (UIXGridView*) grid
{
	return 2;
}

- (NSInteger) cellWidthForGrid:(UIXGridView*) grid
{
	return 100;
}

- (void) UIXGridView: (UIXGridView*) gridView  didSelectCellAtIndexPath:(NSIndexPath*) indexPath
{
#if 0	
	UIXGridViewCell* cell = [gridView cellAtIndexPath:indexPath];
	UIAlertView* v = [[[UIAlertView alloc] initWithTitle:@"You picked" 
												 message:cell.textLabel.text
												delegate:nil 
									   cancelButtonTitle:@"Why yes I did!" 
									   otherButtonTitles:nil] autorelease];
	[v show];
#endif	
	[gridView deselectCellAtIndexPath:indexPath animated:YES];
	[[gridView cellAtIndexPath:currentSelection] setOverlayView:nil];
	self.currentSelection = indexPath;
	UIXGridViewCell* cell = [gridView cellAtIndexPath:currentSelection];
	CGRect frame = cell.contentView.frame;
	overlay.frame = frame;
	[cell setOverlayView:overlay];
}

- (UIColor*) UIXGridView: (UIXGridView*) gridView selectionBackgroundColorForCellAtIndexPath:(NSIndexPath*) indexPath
{
	return [UIColor orangeColor];
}

@end
