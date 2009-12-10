//
//  FancySelectCell.m
//  FancySelect
//
//  Created by gumbright on 8/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FancySelectCell.h"


@implementation BorderView

@synthesize selected;

- (void) drawRect:(CGRect) rect
{
	CGRect frame = CGRectInset(rect, 5, 5);
	UIColor* borderColor = [[UIColor alloc] initWithWhite:1.0 alpha:0.75];
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, 5);
	CGContextSetAlpha(context, 0.75);
	CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
	
//	selectionColor = [((UIXGridView*) self.superview) selectionColor];
//	[selectionColor set];

	if (selected)
	{	
		CGContextSetFillColorWithColor(context, borderColor.CGColor);
	}	
	
	///////////////////
	int corner_radius = 7;
	int x_left = frame.origin.x;  
	int x_left_center = frame.origin.x + corner_radius;  
	int x_right_center = frame.origin.x + frame.size.width - corner_radius;  
	int x_right = frame.origin.x + frame.size.width;  
	int y_top = frame.origin.y;  
	int y_top_center = frame.origin.y + corner_radius;  
	int y_bottom_center = frame.origin.y + frame.size.height - corner_radius;  
	int y_bottom = frame.origin.y + frame.size.height;  
	
	/* Begin! */  
	CGContextBeginPath(context);  
	CGContextMoveToPoint(context, x_left, y_top_center);  
	
	/* First corner */  
	CGContextAddArcToPoint(context, x_left, y_top, x_left_center, y_top, corner_radius);  
	CGContextAddLineToPoint(context, x_right_center, y_top);  
	
	/* Second corner */  
	CGContextAddArcToPoint(context, x_right, y_top, x_right, y_top_center, corner_radius);  
	CGContextAddLineToPoint(context, x_right, y_bottom_center);  
	
	/* Third corner */  
	CGContextAddArcToPoint(context, x_right, y_bottom, x_right_center, y_bottom, corner_radius);  
	CGContextAddLineToPoint(context, x_left_center, y_bottom);  
	
	/* Fourth corner */  
	CGContextAddArcToPoint(context, x_left, y_bottom, x_left, y_bottom_center, corner_radius);  
	CGContextAddLineToPoint(context, x_left, y_top_center);  
	
	/* Done */  
	CGContextClosePath(context);  
	
	if (selected)
	{
		CGContextDrawPath(context, kCGPathFill);		
	}
	else
	{
		CGContextDrawPath(context, kCGPathStroke);		
	}	
	///////////////////
}

@end

@implementation FancySelectCell

@synthesize borderView;
@synthesize iconView;
@synthesize cellLabel;
@synthesize onImage;
@synthesize offImage;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (id) initWithReuseIdentifier:(NSString*) reuseId
{
	if (self = [super initWithStyle:UIXGridViewCellStyleDefault reuseIdentifier: reuseId])
	{
		self.backgroundColor = [UIColor clearColor];
		
		//border view
		CGRect frame;
		
		borderView = [[BorderView alloc] initWithFrame:frame];
		borderView.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:borderView];
		
		iconView = [[UIImageView alloc] initWithFrame:frame];
		iconView.contentMode = UIViewContentModeCenter;
		[self.contentView addSubview: iconView];
		
		cellLabel = [[UILabel alloc] initWithFrame:frame];
		cellLabel.backgroundColor = [UIColor clearColor];
		cellLabel.textColor = [UIColor whiteColor];
		cellLabel.textAlignment = UITextAlignmentCenter;
		
		[self.contentView addSubview:cellLabel];
	}
	
	return self;
}

- (void)layoutSubviews
{
	CGRect frame;
	CGRect bounds;
	
	frame = self.frame;
	bounds = self.bounds;
	
	borderView.frame = bounds;
	
	frame = CGRectInset(bounds, 10, 10);
	frame.size.height -= 30; 
	iconView.frame = frame;
	
	frame = CGRectInset(bounds, 10, 10);
	frame.origin.y = frame.size.height - 30;
	frame.size.height = 30;
	cellLabel.frame = frame;
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}



- (void)dealloc {
    [super dealloc];
}

- (void) setSelected:(BOOL) f
{
	if (f)
	{	
		iconView.image = onImage;
		cellLabel.textColor = [UIColor blueColor];
	}
	else
	{
		iconView.image = offImage;
		cellLabel.textColor = [UIColor whiteColor];
	}
	borderView.selected = f;
	[borderView setNeedsDisplay];
	[iconView setNeedsDisplay];
	[super setSelected:f];
}		

@end

