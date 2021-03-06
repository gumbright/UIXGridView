//
//  RootViewController.m
//  GridViewExamples
//
//  Created by gumbright on 8/17/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RootViewController.h"
#import "ConstrainedMomentaryViewController.h"
#import "SpanningViewController.h"
#import "HorzContrainedSingleHeaderViewController.h"
#import "VertConstrainedMultipleViewController.h"
#import "CustomViewsController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.title = @"Examples";
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.

	if ([indexPath row] == 0)
	{
		cell.textLabel.text = @"Constrained Momentary";
		cell.detailTextLabel.text = @"simple select";
	}
	else if ([indexPath row] == 1)
	{
		cell.textLabel.text = @"Horz Constrained";
		cell.detailTextLabel.text = @"Single Select w/ header & footer";
	}
	else if ([indexPath row] == 2)
	{
		cell.textLabel.text = @"Vert Constrainted";
		cell.detailTextLabel.text = @"Multiple selection, custom icon, alt pos";
	}	
	else if ([indexPath row] == 3)
	{
		cell.textLabel.text = @"Spanning cells";
		cell.detailTextLabel.text = @"simple select";
	}
	else if ([indexPath row] == 4)
	{
		cell.textLabel.text = @"Constrained";
		cell.detailTextLabel.text = @"custom highlight & select";
	}
//	else if ([indexPath row] == 5)
//	{
//		cell.textLabel.text = @"Grid on scroll";
//		cell.detailTextLabel.text = @"Grid on paging scroll view";
//	}
//	else if ([indexPath row] == 6)
//	{
//		cell.textLabel.text = @"Spanning cells";
//		cell.detailTextLabel.text = @"Cells that cover multiple grid spaces";
//	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch ([indexPath row])
	{
		case 0:
		{
			ConstrainedMomentaryViewController* constrainedMomentary = [[ConstrainedMomentaryViewController alloc] init];
			[self.navigationController pushViewController:constrainedMomentary animated:YES];
			[constrainedMomentary release];
		}
			break;
			
		case 1:
		{
			HorzContrainedSingleHeaderViewController* vc = [[HorzContrainedSingleHeaderViewController alloc] init];
			[self.navigationController pushViewController:vc animated:YES];
			[vc release];
		}
			break;
			
		case 2:
		{
			VertConstrainedMultipleViewController* vc = [[VertConstrainedMultipleViewController alloc] init];
			[self.navigationController pushViewController:vc animated:YES];
			[vc release];
		}
			break;

		case 3:
        {
            SpanningViewController* vc = [[SpanningViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
            break;
            
		case 4:
        {
            CustomViewsController* vc = [[CustomViewsController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
            break;
            
//			
//		case 3:
//		{
//			HeaderFooterViewController* headerFooterViewController = [[HeaderFooterViewController alloc] init];
//			[self.navigationController pushViewController:headerFooterViewController animated:YES];
//			[headerFooterViewController release];
//		}
//			break;
//			
//		case 4:
//		{
//			UnconstrainedViewController* unconstrainedViewController = [[UnconstrainedViewController alloc] init];
//			[self.navigationController pushViewController:unconstrainedViewController animated:YES];
//			[unconstrainedViewController release];
//		}
//			break;
//			
//		case 5:
//		{
//			GridOnScrollViewController* gridOnScrollViewController = [[GridOnScrollViewController alloc] initWithNibName:@"GridOnScroll" bundle:nil];
//			[self.navigationController pushViewController:gridOnScrollViewController animated:YES];
//			[gridOnScrollViewController release];
//		}
//			break;
//			
//		case 6:
//		{
//			SpanningViewController* vc = [[SpanningViewController alloc] init];
//			[self.navigationController pushViewController:vc animated:YES];
//			[vc release];
//		}
//			break;
			
	}
}


/*
// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Navigation logic may go here -- for example, create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController animated:YES];
	// [anotherViewController release];
}
*/


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

