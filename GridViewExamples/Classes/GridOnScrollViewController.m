    //
//  GridOnScrollViewController.m
//  GridViewExamples
//
//  Created by gumbright on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GridOnScrollViewController.h"
#import "UIXGridView.h"
#import "UIXGridViewCell.h"

@implementation GridOnScrollViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
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
	
	CGSize sz = scroll.frame.size;
	scroll.contentSize = CGSizeMake(sz.width*2, sz.height);
	
	grid = [[UIXGridView alloc] initWithFrame:CGRectMake(0, 0, gridContainer.frame.size.width, gridContainer.frame.size.height) 
											   andStyle:UIXGridViewStyleConstrained];
	grid.gridDelegate = self;
	grid.dataSource = self;
//	grid.selectionColor = [UIColor clearColor];
	[gridContainer addSubview:grid];
	[grid release];
}

- (void) viewWillAppear:(BOOL)animated
{
	NSUInteger ndxes[2] = {0,3};
	NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ndxes length:2];
	
	[table selectRowAtIndexPath:indexPath 
					   animated:NO 
				 scrollPosition:UITableViewScrollPositionTop];
	
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (NSInteger) numberOfColumnsForGrid:(UIXGridView*) grid
{
	return 2;
}

- (NSInteger) numberOfRowsForGrid: (UIXGridView*) grid
{
	return 3;
}

- (UIXGridViewCell*) UIXGridView:(UIXGridView*) grid cellForIndexPath:(NSIndexPath*) indexPath
{
	UIXGridViewCell* cell = [grid dequeueReusableCellWithIdentifier:@"goscell"];
	
	if (cell == nil)
	{
		cell = [[UIXGridViewCell alloc] initWithStyle:UIXGridViewCellStyleDefault reuseIdentifier:@"goscell"];
		
		UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 140, 130)];
		iv.tag = 111;
		[cell.contentView addSubview:iv];
		[iv release];
	}
	
	UIImageView* iv = [cell.contentView viewWithTag:111];
	
	switch ([indexPath row]) 
	{
		case 0:
		{
			switch ([indexPath column]) 
			{
				case 0:
				{
					iv.image = [UIImage imageNamed:@"mercury.jpeg"];
				}
					break;
				case 1:
				{
					iv.image = [UIImage imageNamed:@"venus.jpeg"];
				}
					break;
			}
		}
			break;
			
		case 1:
		{
			switch ([indexPath column]) 
			{
				case 0:
				{
					iv.image = [UIImage imageNamed:@"mars.jpeg"];
				}
					break;
				case 1:
				{
					iv.image = [UIImage imageNamed:@"jupiter.jpeg"];
				}
					break;
			}
		}
			break;
			
		case 2:
		{
			switch ([indexPath column]) 
			{
				case 0:
				{
					iv.image = [UIImage imageNamed:@"saturn.jpeg"];
				}
					break;
				case 1:
				{
					iv.image = [UIImage imageNamed:@"uranus.jpeg"];
				}
					break;
			}
		}
			break;
	}
	iv.highlightedImage = [UIImage imageNamed:@"earth.jpeg"];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"goscell"];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goscell"];
	}
	
	cell.textLabel.text = @"Banana";
	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"will select cell");
	return indexPath;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) removeSelection:(NSIndexPath*) indexPath
{
	[grid deselectCellAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void) UIXGridView: (UIXGridView*) gridView  didSelectCellAtIndexPath:(NSIndexPath*) indexPath
{
	NSLog(@"did select cell");
	[self performSelector:@selector(removeSelection:) withObject: indexPath afterDelay:0];
}
@end
