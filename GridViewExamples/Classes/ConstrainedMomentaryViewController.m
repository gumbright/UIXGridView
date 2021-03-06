//
//  ConstrainedMomentaryViewController.m
//  GridViewExamples
//
//  Created by gumbright on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ConstrainedMomentaryViewController.h"
#import "UIXGridView.h"
#import "UIXGridViewCell.h"

@implementation ConstrainedMomentaryViewController

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
	grid = [[UIXGridView alloc] initWithFrame:frame andStyle:UIXGridViewStyleConstrained];

	grid.gridDelegate = self;
	grid.dataSource = self;
	
	grid.backgroundColor = [UIColor whiteColor];
//	grid.selectionColor = [UIColor redColor];
	
	self.title = @"Constrained Momentary";
    grid.selectionStyle = UIXGridViewSelectionStyleMomentary;
    
	[view addSubview:grid];
	[grid release];
	
	labels = [[NSArray arrayWithObjects:[NSArray arrayWithObjects:@"Mercury",@"Venus",@"Earth",nil],
										[NSArray arrayWithObjects:@"Mars",@"Jupiter",@"Saturn",nil],
										[NSArray arrayWithObjects:@"Neptune",@"Uranus",@"Pluto",nil],nil] retain];
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
- (void)dealloc 
{
    [labels release];
    
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
	
	switch (indexPath.row)
	{
		case 0:
		{
			switch (indexPath.column)
			{
				case 0:
				{
					cell.textLabel.text = [[labels objectAtIndex:0] objectAtIndex:0];
					cell.imageView.image = [UIImage imageNamed:@"mercury.jpeg"];
				}
				break;
					
				case 1:
				{
					cell.textLabel.text = [[labels objectAtIndex:0] objectAtIndex:1];
					cell.imageView.image = [UIImage imageNamed:@"venus.jpeg"];
				}
				break;
				
				case 2:
				{
					cell.textLabel.text = [[labels objectAtIndex:0] objectAtIndex:2];
					cell.imageView.image = [UIImage imageNamed:@"earth.jpeg"];
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
					cell.textLabel.text = [[labels objectAtIndex:1] objectAtIndex:0];
					cell.imageView.image = [UIImage imageNamed:@"mars.jpeg"];
				}
				break;
						
				case 1:
				{
					cell.textLabel.text = [[labels objectAtIndex:1] objectAtIndex:1];
					cell.imageView.image = [UIImage imageNamed:@"jupiter.jpeg"];
				}
				break;
						
				case 2:
				{
					cell.textLabel.text = [[labels objectAtIndex:1] objectAtIndex:2];
					cell.imageView.image = [UIImage imageNamed:@"saturn.jpeg"];
				}
				break;
					
			}
		}
		break;

		case 2:
		{
			switch (indexPath.column)
			{
				case 0:
				{
					cell.textLabel.text = [[labels objectAtIndex:2] objectAtIndex:0];
					cell.imageView.image = [UIImage imageNamed:@"neptune.jpeg"];
				}
				break;
						
				case 1:
				{
					cell.textLabel.text = [[labels objectAtIndex:2] objectAtIndex:1];
					cell.imageView.image = [UIImage imageNamed:@"uranus.jpeg"];
				}
				break;
						
				case 2:
				{
					cell.textLabel.text = [[labels objectAtIndex:2] objectAtIndex:2];
					cell.imageView.image = [UIImage imageNamed:@"pluto.jpeg"];
				}
				break;
						
			}
		}
		break;

	}
	
	return cell;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (NSInteger) numberOfColumnsForGrid:(UIXGridView*) grid
{
	return 3;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (NSInteger) numberOfRowsForGrid: (UIXGridView*) grid
{
	return 3;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) UIXGridView: (UIXGridView*) gridView  willSelectCellAtIndexPath:(NSIndexPath*) indexPath
{
//	NSLog(@"hit willSelectCellAtIndexPath");
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) removeSelection:(NSIndexPath*) indexPath
{
	[grid deselectCellAtIndexPath:indexPath animated:YES];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) UIXGridView: (UIXGridView*) gridView  didSelectCellAtIndexPath:(NSIndexPath*) indexPath
{
	UIAlertView* v = [[[UIAlertView alloc] initWithTitle:@"You picked" 
												 message:[[labels objectAtIndex:[indexPath row]] objectAtIndex:[indexPath column]]
												delegate:nil 
									   cancelButtonTitle:@"Why yes I did!" 
									   otherButtonTitles:nil] autorelease];
	[v show];
	
	[self performSelector:@selector(removeSelection:) withObject: indexPath afterDelay:0.25];
//	[gridView deselectCellAtIndexPath:indexPath animated:YES];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (BOOL) UIXGridView: (UIXGridView*) gridView  shouldSelectCellAtIndexPath:(NSIndexPath*) indexPath
{
	return YES;
}

@end
