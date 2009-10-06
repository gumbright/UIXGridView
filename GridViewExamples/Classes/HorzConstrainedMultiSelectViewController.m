//
//  HorzConstrainedMultiSelectViewController.m
//  GridViewExamples
//
//  Created by gumbright on 8/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HorzConstrainedMultiSelectViewController.h"
#import "UIXGridView.h"
#import "UIXGridViewCell.h"


@implementation HorzConstrainedMultiSelectViewController

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
	UIXGridView* gv =[[UIXGridView alloc] initWithFrame:frame andStyle:UIXGridViewStyle_HorzConstrained selectionType: UIXGridViewSelectionType_Multiple];
	//gv.momentary = NO;
	//gv.multiSelect = YES;
	gv.delegate = self;
	gv.dataSource = self;
	gv.backgroundColor = [UIColor whiteColor];
	gv.selectionColor = [UIColor redColor];
	self.title = @"Horz Constrained Multi Select";
	[view addSubview:gv];
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
	
	
	cell = [gridView dequeueReusableCellWithIdentifier:@"HorzMultiCell"];
	if (cell == nil)
	{
		cell = [[UIXGridViewCell alloc] initWithStyle:UIXGridViewCellStyleDefault reuseIdentifier:@"HorzMultiCell"];
				}
				
	switch (indexPath.row)
	{
		case 0:
		{
			cell.label.text = @"Mercury";
			cell.imageView.image = [UIImage imageNamed:@"mercury.jpeg"];
		}
		break;
					
		case 1:
		{
			cell.label.text = @"Venus";
			cell.imageView.image = [UIImage imageNamed:@"venus.jpeg"];
		}
		break;
					
		case 2:
		{
			cell.label.text = @"Earth";
			cell.imageView.image = [UIImage imageNamed:@"earth.jpeg"];
		}
		break;
					
		case 3:
		{
			cell.label.text = @"Mars";
			cell.imageView.image = [UIImage imageNamed:@"mars.jpeg"];
		}
		break;
					
		case 4:
		{
			cell.label.text = @"Jupiter";
			cell.imageView.image = [UIImage imageNamed:@"jupiter.jpeg"];
		}
		break;
						
		case 5:
		{
			cell.label.text = @"Saturn";
			cell.imageView.image = [UIImage imageNamed:@"saturn.jpeg"];
		}
		break;
					
		case 6:
		{
			cell.label.text = @"Neptune";
			cell.imageView.image = [UIImage imageNamed:@"neptune.jpeg"];
		}
		break;
					
		case 7:
		{
			cell.label.text = @"Uranus";
			cell.imageView.image = [UIImage imageNamed:@"uranus.jpeg"];
		}
		break;
					
		case 8:
		{
			cell.label.text = @"Pluo";
			cell.imageView.image = [UIImage imageNamed:@"pluto.jpeg"];
		}
		break;
					
		default:
			cell = nil;
		break;
					
	}
	
	
	return cell;
}

- (NSInteger) numberOfColumnsForGrid:(UIXGridView*) grid
{
	return 2;
}

- (NSInteger) numberOfRowsForGrid: (UIXGridView*) grid
{
	return 9;
}

- (NSInteger) cellHeightForGrid:(UIXGridView*) grid
{
	return 100;
}

- (void) UIXGridView: (UIXGridView*) gridView  didSelectCellForIndexPath:(NSIndexPath*) indexPath
{
}

@end
