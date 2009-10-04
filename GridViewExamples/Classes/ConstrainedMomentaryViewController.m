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
	UIXGridView* gv =[[UIXGridView alloc] initWithFrame:frame andStyle:UIXGridViewStyle_Constrained selectionType: UIXGridViewSelectionType_Momentary];
	//gv.momentary = YES;
	gv.delegate = self;
	gv.dataSource = self;
	gv.backgroundColor = [UIColor whiteColor];
	gv.selectionColor = [UIColor redColor];
	self.title = @"Constrained Momentary";
	[view addSubview:gv];
	labels = [[NSArray arrayWithObjects:[NSArray arrayWithObjects:@"Mercuy",@"Venus",@"Earth",nil],
			  [NSArray arrayWithObjects:@"Mars",@"Jupiter",@"Saturn",nil],
			  [NSArray arrayWithObjects:@"Neptune",@"Uranus",@"Pluto",nil]] retain];
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
	
	cell = [gridView dequeueReusableCell];
	if (cell == nil)
	{
		cell = [[UIXGridViewCell alloc] init];
	}
	
	switch (indexPath.row)
	{
		case 0:
		{
			switch (indexPath.column)
			{
				case 0:
				{
					cell.label.text = [[labels objectAtIndex:0] objectAtIndex:0];
					cell.imageView.image = [UIImage imageNamed:@"mercury.jpeg"];
				}
				break;
					
				case 1:
				{
					cell.label.text = [[labels objectAtIndex:0] objectAtIndex:1];
					cell.imageView.image = [UIImage imageNamed:@"venus.jpeg"];
				}
				break;
				
				case 2:
				{
					cell.label.text = [[labels objectAtIndex:0] objectAtIndex:2];
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
					cell.label.text = [[labels objectAtIndex:1] objectAtIndex:0];
					cell.imageView.image = [UIImage imageNamed:@"mars.jpeg"];
				}
				break;
						
				case 1:
				{
					cell.label.text = [[labels objectAtIndex:1] objectAtIndex:1];
					cell.imageView.image = [UIImage imageNamed:@"jupiter.jpeg"];
				}
				break;
						
				case 2:
				{
					cell.label.text = [[labels objectAtIndex:1] objectAtIndex:2];
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
					cell.label.text = [[labels objectAtIndex:2] objectAtIndex:0];
					cell.imageView.image = [UIImage imageNamed:@"neptune.jpeg"];
				}
				break;
						
				case 1:
				{
					cell.label.text = [[labels objectAtIndex:2] objectAtIndex:1];
					cell.imageView.image = [UIImage imageNamed:@"uranus.jpeg"];
				}
				break;
						
				case 2:
				{
					cell.label.text = [[labels objectAtIndex:2] objectAtIndex:2];
					cell.imageView.image = [UIImage imageNamed:@"pluto.jpeg"];
				}
				break;
						
			}
		}
		break;

	}
	
	return cell;
}

- (NSInteger) numberOfColumnsForGrid:(UIXGridView*) grid
{
	return 3;
}

- (NSInteger) numberOfRowsForGrid: (UIXGridView*) grid
{
	return 3;
}

- (void) UIXGridView: (UIXGridView*) gridView  didSelectCellForIndexPath:(NSIndexPath*) indexPath
{
	UIAlertView* v = [[[UIAlertView alloc] initWithTitle:@"You picked" 
												 message:[[labels objectAtIndex:[indexPath row]] objectAtIndex:[indexPath column]]
												delegate:nil 
									   cancelButtonTitle:@"Why yes I did!" 
									   otherButtonTitles:nil] autorelease];
	[v show];
}


@end
