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

- (UIXGridViewCell*) getCellForGridView:(UIXGridView*) gridView
{
	UIXGridViewCell* cell=nil;
    
	cell = [gridView dequeueReusableCellWithIdentifier:@"VertSingleCell"];
	if (cell == nil)
	{
		cell = [[[UIXGridViewCell alloc] initWithStyle:UIXGridViewCellStyleDefault reuseIdentifier:@"VertSingleCell"] autorelease];
//		cell = [[[UIXGridViewCell alloc] initWithStyle:UIXGridViewCellStyleDefault reuseIdentifier:nil] autorelease];
	}
    
    return cell;
}

- (UIXGridViewCell*) UIXGridView:(UIXGridView*) gridView cellForIndexPath:(NSIndexPath*) indexPath
{
	UIXGridViewCell* cell=nil;
		
	switch (indexPath.row)
	{
		case 0:
		{
            cell = [self getCellForGridView:gridView];
            
			switch (indexPath.column)
			{
				case 0:
				{
					cell.imageView.image = [UIImage imageNamed:@"mercury.jpeg"];
					cell.textLabel.text = @"Mercury";
				}
					break;
					
				case 1:
				{
					cell.imageView.image = [UIImage imageNamed:@"venus.jpeg"];
					cell.textLabel.text = @"Venus";
				}
					break;
					
				case 2:
				{
					cell.imageView.image = [UIImage imageNamed:@"earth.jpeg"];
					cell.textLabel.text = @"Earth";
				}
					break;
					
				case 3:
				{
					cell.imageView.image = [UIImage imageNamed:@"mars.jpeg"];
					cell.textLabel.text = @"Mars";
				}
					break;
					
				case 4:
				{
					cell.imageView.image = [UIImage imageNamed:@"jupiter.jpeg"];
					cell.textLabel.text = @"Jupiter";
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
                    cell = [self getCellForGridView:gridView];
					cell.imageView.image = [UIImage imageNamed:@"saturn.jpeg"];
					cell.textLabel.text = @"Saturn";
				}
					break;
					
				case 1:
				{
                    cell = [self getCellForGridView:gridView];
					cell.imageView.image = [UIImage imageNamed:@"neptune.jpeg"];
					cell.textLabel.text = @"Neptune";
				}
					break;
					
				case 2:
				{
                    cell = [self getCellForGridView:gridView];
					cell.imageView.image = [UIImage imageNamed:@"uranus.jpeg"];
					cell.textLabel.text = @"Uranus";
				}
					break;
					
				case 3:
				{
                    cell = [self getCellForGridView:gridView];
					cell.imageView.image = [UIImage imageNamed:@"pluto.jpeg"];
					cell.textLabel.text = @"Pluto";
				}
					break;
					
				default:
					cell = nil;
					break;
					
			}
		}
			break;
	}
		
    //dumpViews(cell,@"cell",@" ");
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
