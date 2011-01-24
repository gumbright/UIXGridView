//
//  UIXGridViewSpanningCell.h
//  GridViewExamples
//
//  Created by gumbright on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIXGridViewCell.h"

#pragma mark -
#pragma mark UIXGridViewSpannedCell

@interface UIXGridViewSpannedCell : UIXGridViewCell 

//- (id)initWithFrame:(CGRect) frame andStyle:(NSInteger) style;
- (id)init;

@end

#pragma mark -
#pragma mark UIXGridViewSpanningCell

@interface UIXGridViewSpanningCell : UIXGridViewCell 
{
	NSUInteger widthInCells; //in cells
	NSUInteger heightInCells; //in cells
}

@property (assign) NSUInteger widthInCells;
@property (assign) NSUInteger heightInCells;

- (id)initWithStyle:(UIXGridViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier
	   widthInCells:(NSUInteger) w 
	  heightInCells:(NSUInteger) h;

@end
