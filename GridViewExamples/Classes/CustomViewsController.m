//
//  CustomViewsController.m
//  GridViewExamples
//
//  Created by Guy Umbright on 5/21/11.
//  Copyright 2011 Kickstand Software. All rights reserved.
//

#import "CustomViewsController.h"


@implementation CustomViewsController

@synthesize gridContainer;

- (id)init
{
    self = [super initWithNibName:@"CustomViews" bundle:nil];
    if (self) 
    {
        contents = [[NSMutableArray arrayWithCapacity:16] retain];
        
        for (NSInteger ndx =0; ndx < 16; ++ndx)
        {
            [contents addObject:[NSNumber numberWithInt:ndx]];
            
            srandom(time(NULL));
        }
    }
    return self;
}

- (void)dealloc
{
    [contents release];
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
	CGRect frame = gridContainer.bounds;
    
	grid = [[UIXGridView alloc] initWithFrame:frame andStyle:UIXGridViewStyleHorzConstrained];
    
	grid.gridDelegate = self;
	grid.dataSource = self;
	
	grid.backgroundColor = [UIColor whiteColor];
	
	self.title = @"Custom views";
    grid.selectionStyle = UIXGridViewSelectionStyleSingle;
    
	[gridContainer addSubview:grid];
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
    
    NSInteger cellNdx = ([indexPath row] * 4) + [indexPath column];
    if (cellNdx >= [contents count])
    {
        return nil;
    }
    
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
    
    NSNumber* n = [contents objectAtIndex:cellNdx];
    NSString* imageName = [NSString stringWithFormat:@"%@",n];
    UIImage* img = [UIImage imageNamed:imageName];
    
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
    NSInteger n = ([contents count]/4) + (([contents count]%4 > 0) ? 1 : 0);
	return n;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (NSInteger) cellHeightForGrid: (UIXGridView*) grid
{
    return 80;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (IBAction) plusPressed:(id) sender;
{
    NSNumber* n = [NSNumber numberWithInteger: random() % 16];
    [contents addObject:n];
    [grid reloadData];
    
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (IBAction) minusPressed:(id) sender;
{
    if ([contents count] > 0)
    {
        [contents removeLastObject];
        [grid reloadData];
    }
}
@end
