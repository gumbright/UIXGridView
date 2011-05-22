//
//  CustomViewsController.m
//  GridViewExamples
//
//  Created by Guy Umbright on 5/21/11.
//  Copyright 2011 Kickstand Software. All rights reserved.
//

#import "CustomViewsController.h"


@implementation CustomViewsController

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	CGRect frame = CGRectMake(0,0,320,320);
    
	grid = [[UIXGridView alloc] initWithFrame:frame andStyle:UIXGridViewStyleConstrained];
    
	grid.gridDelegate = self;
	grid.dataSource = self;
	
	grid.backgroundColor = [UIColor whiteColor];
	
	self.title = @"Custom views";
    grid.selectionStyle = UIXGridViewSelectionStyleSingle;
    
	[self.view addSubview:grid];
	[grid release];
}


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

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (UIXGridViewCell*) UIXGridView:(UIXGridView*) gridView cellForIndexPath:(NSIndexPath*) indexPath
{
	UIXGridViewCell* cell;
    UIImageView* iv;
    
	cell = [gridView dequeueReusableCellWithIdentifier:@"ConstrainedMomentaryCell"];
	if (cell == nil)
	{
		cell = [[[UIXGridViewCell alloc] initWithStyle:UIXGridViewCellStyleDefault reuseIdentifier:@"ConstrainedMomentaryCell"] autorelease];
         iv = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 48, 48)];
        [cell.contentView addSubview:iv];
        iv.tag = 1234;
        [iv release];
        
        UIImage* img;
        
        img = [UIImage imageNamed:@"highlight"];
        iv = [[UIImageView alloc] initWithImage:img];
        cell.highlightBackgroundView = iv;
        [iv release];
        
        
        img = [UIImage imageNamed:@"select"];
        iv = [[UIImageView alloc] initWithImage:img];
        cell.selectionOverlayView = iv;
        [iv release];
	}
	
	iv = [cell.contentView viewWithTag:1234];
    
    NSInteger imageNdx = ([indexPath row] * 4) + [indexPath column];
    UIImage* img = [UIImage imageNamed:[NSString stringWithFormat:@"%d",imageNdx]];
    
    iv.image = img;
	return cell;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (NSInteger) numberOfColumnsForGrid:(UIXGridView*) grid
{
	return 4;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (NSInteger) numberOfRowsForGrid: (UIXGridView*) grid
{
	return 4;
}

@end
