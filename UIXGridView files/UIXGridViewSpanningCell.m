//
//  UIXGridViewSpanningCell.m
//  GridViewExamples
//
//  Created by gumbright on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIXGridViewSpanningCell.h"

#pragma mark -
#pragma mark UIXGridViewSpannedCell

@implementation UIXGridViewSpannedCell

- (id)init
{
	self = [super initWithStyle:UIXGridViewCellStyleDefault reuseIdentifier:nil];
	return self;
}
@end


#pragma mark -
#pragma mark UIXGridViewSpanningCell

@implementation UIXGridViewSpanningCell

@synthesize widthInCells;
@synthesize heightInCells;

///////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UIXGridViewCellStyle) style 
	reuseIdentifier:(NSString*) reuseIdentifier
	widthInCells: (NSUInteger) w
	heightInCells: (NSUInteger) h
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		self.widthInCells = w;
		self.heightInCells = h;
	}
	
	return self;
}

@end
