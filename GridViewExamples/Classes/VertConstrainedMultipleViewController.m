//
//  VertConstrainedMultipleViewController.m
//  GridViewExamples
//
//  Created by Guy Umbright on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VertConstrainedMultipleViewController.h"
#import "UIXGridView.h"

@implementation VertConstrainedMultipleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	CGRect frame = CGRectMake(0,0,320,416);
	UIView* view = [[UIView alloc] initWithFrame:frame];
	self.view = view;
	UIXGridView* gv =[[UIXGridView alloc] initWithFrame:frame andStyle:UIXGridViewStyleVertConstrained];
	gv.selectionStyle = UIXGridViewSelectionStyleMultiple;
    
	gv.gridDelegate = self;
	gv.dataSource = self;
    
	gv.backgroundColor = [UIColor whiteColor];
	self.title = @"Vert Constr. Multiple";

	[view addSubview:gv];
	[gv release];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIXGridViewCell*) UIXGridView:(UIXGridView*) gridView cellForIndexPath:(NSIndexPath*) indexPath
{
	UIXGridViewCell* cell;
		
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
					cell.textLabel.text = @"Pluto";
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

@end
