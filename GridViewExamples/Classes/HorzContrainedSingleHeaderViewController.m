//
//  HorzContrainedSingleHeaderViewController.m
//  GridViewExamples
//
//  Created by Guy Umbright on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HorzContrainedSingleHeaderViewController.h"


@implementation HorzContrainedSingleHeaderViewController

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

- (void)loadView 
{
	CGRect frame = CGRectMake(0,0,320,416);
	UIView* view = [[UIView alloc] initWithFrame:frame];
	self.view = view;
	UIXGridView* gv =[[UIXGridView alloc] initWithFrame:frame andStyle:UIXGridViewStyleHorzConstrained];
    gv.selectionStyle = UIXGridViewSelectionStyleSingle;
    
	gv.gridDelegate = self;
	gv.dataSource = self;
	gv.backgroundColor = [UIColor whiteColor];
	
	gv.horizontalGridLineWidth = 3;
	gv.verticalGridLineWidth = 3;
	gv.borderGridLineWidth = 3;
	
	self.title = @"Horz Constrained Single";
	[view addSubview:gv];
	[gv release];
    
	frame = CGRectMake(0,0,0,50);
	view = [[UIView alloc] initWithFrame:frame];
	view.backgroundColor = [UIColor yellowColor];
	gv.headerView = view;
	
	frame = CGRectMake(0,0,0,50);
	view = [[UIView alloc] initWithFrame:frame];
	view.backgroundColor = [UIColor orangeColor];
	gv.footerView = view;
    
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
	
	
	cell = [gridView dequeueReusableCellWithIdentifier:@"HorzMultiCell"];
	if (cell == nil)
	{
		cell = [[[UIXGridViewCell alloc] initWithStyle:UIXGridViewCellStyleDefault reuseIdentifier:@"HorzMultiCell"] autorelease];
    }
    
	switch (indexPath.row)
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
            
		case 5:
		{
			cell.textLabel.text = @"Saturn";
			cell.imageView.image = [UIImage imageNamed:@"saturn.jpeg"];
		}
            break;
            
		case 6:
		{
			cell.textLabel.text = @"Neptune";
			cell.imageView.image = [UIImage imageNamed:@"neptune.jpeg"];
		}
            break;
            
		case 7:
		{
			cell.textLabel.text = @"Uranus";
			cell.imageView.image = [UIImage imageNamed:@"uranus.jpeg"];
		}
            break;
            
		case 8:
		{
			cell.textLabel.text = @"Pluo";
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

- (void) UIXGridView: (UIXGridView*) gridView  didSelectCellAtIndexPath:(NSIndexPath*) indexPath
{
}

@end
