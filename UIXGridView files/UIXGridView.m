//
//  UIXGridView.m
//  GridView
//
//  Created by gumbright on 8/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

/*
 Copyright (c) 2009, Guy Umbright
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the <organization> nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY Guy Umbright ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL Guy Umbright BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */ 

#import "UIXGridView.h"
#import "UIXGridViewCell.h"

@implementation UIXGridView

@synthesize columns;
@synthesize rows;
@synthesize constrainHorzToScreenSize;
@synthesize constrainVertToScreenSize;
@synthesize customSelect;
@synthesize dataSource;
//@synthesize columnWidth;
//@synthesize rowHeight;
@synthesize cellInsets;
@synthesize style;
@synthesize selectionType;
@synthesize selectionColor;
//@synthesize selectedCell;
@synthesize headerView;
@synthesize footerView;

@synthesize horizontalGridLineWidth;
@synthesize verticalGridLineWidth;
@synthesize borderGridLineWidth;
@synthesize gridLineColor;

@synthesize cellWidth;
@synthesize cellHeight;

//////////////////////////////////////
//
//////////////////////////////////////
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) setup
{
	constrainHorzToScreenSize = YES;
	constrainVertToScreenSize = YES;
	
	columns = 0;
	rows = 0;
	
	hasNewData = YES;
	cells = [[NSMutableDictionary dictionary] retain];
	selectionIndexPaths = [[NSMutableSet set] retain];
	cellQueue = [[NSMutableArray array] retain];
	
	cellInsets.top = cellInsets.right = cellInsets.bottom = cellInsets.left = 3;
	
	self.contentMode = UIViewContentModeRedraw;

	reusableCells = [[NSMutableDictionary dictionary] retain];
	[self reloadData];
}


//////////////////////////////////////
//
//////////////////////////////////////
- (BOOL) touchesShouldCancelInContentView:(UIView*) view
{
	if (self.selectionType == UIXGridViewSelectionType_Momentary )
	{	
		return NO;
	}
	else
	{
		return YES;
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (id)initWithFrame:(CGRect) frame andStyle:(NSInteger) s selectionType:(NSInteger) selType
{
	
	if (self = [super initWithFrame:frame])
	{
		style = s;
		selectionType = selType;
		initialSetupDone = NO;

		super.delegate = self;
//		cellQueue = [[NSMutableArray array] retain];
		//cells = [[NSMutableDictionary dictionary] retain];
//		selectionIndexPaths = [[NSMutableSet set] retain];
		//[self setup];
	}
	
	return self;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) reloadData
{
	hasNewData = YES;
	[self setNeedsLayout];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) enqueueCell:(UIXGridViewCell*) cell
{
	NSMutableArray* arr = [reusableCells objectForKey:cell.reuseIdentifier];
	if (arr == nil)
	{
		arr = [NSMutableArray array];
		[reusableCells setObject:arr forKey:cell.reuseIdentifier];
	}
	
	[cell prepareForReuse];
	
	[arr addObject:cell]; 
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) calcGeometry
{
	
	switch (style)
	{
		case UIXGridViewStyle_Constrained:
		{
			columns = [self.dataSource numberOfColumnsForGrid:self];
			rows = [self.dataSource numberOfRowsForGrid:self];	
			
			contentSize.width = self.frame.size.width;
			contentSize.height = self.frame.size.height;
			
			CGFloat workHeight = self.frame.size.height;
			if (headerView)
			{
				workHeight -= headerView.frame.size.height;
			}
			
			if (footerView)
			{
				workHeight -= footerView.frame.size.height;
			}
			
			cellHeight = (workHeight - ((borderGridLineWidth * 2) + (horizontalGridLineWidth * (rows - 1))))/rows;
			cellWidth = (contentSize.width - ((borderGridLineWidth * 2) + (verticalGridLineWidth * (columns - 1)))) / columns;
		}
			break;
			
		case UIXGridViewStyle_HorzConstrained:
		{
			//set rows cols
			columns = [self.dataSource numberOfColumnsForGrid:self];
			rows = [self.dataSource numberOfRowsForGrid:self];
			
			cellWidth = (contentSize.width - ((borderGridLineWidth * 2) + (verticalGridLineWidth * (columns - 1)))) / columns;
			contentSize.width = self.frame.size.width;
			
			cellHeight = [self.dataSource cellHeightForGrid:self];
			contentSize.height = (borderGridLineWidth * 2) + 
			(horizontalGridLineWidth * (rows-1)) + 
			(cellHeight * rows);
			
			if (headerView)
			{
				contentSize.height += headerView.frame.size.height;
			}
			
			if (footerView)
			{
				contentSize.height += footerView.frame.size.height;
			}
		}
			break;
			
		case UIXGridViewStyle_VertConstrained:
		{
			//set rows cols
			columns = [self.dataSource numberOfColumnsForGrid:self];
			rows = [self.dataSource numberOfRowsForGrid:self];
			
			cellWidth = [self.dataSource cellWidthForGrid:self];
			contentSize.width = (borderGridLineWidth * 2) + 
							(verticalGridLineWidth * (columns-1)) + 
							(cellWidth * columns);
			
			contentSize.height = self.frame.size.height;			
			CGFloat workHeight = contentSize.height;
			if (headerView)
			{
				workHeight -= headerView.frame.size.height;
			}
			
			if (footerView)
			{
				workHeight -= footerView.frame.size.height;
			}
			
			cellHeight = round((workHeight - ((borderGridLineWidth * 2) + (horizontalGridLineWidth * (rows - 1))))/rows);
		}
			break;
			
		case UIXGridViewStyle_Unconstrained:
		{
		}
			break;
	}
	
	CGFloat work = self.frame.size.width - (borderGridLineWidth * 2);
	work -= cellWidth;
	numHorzCellsVisible = (work / (cellWidth + verticalGridLineWidth))+1;
	
	
	work = self.frame.size.height - (borderGridLineWidth * 2);
	work -= cellHeight;
	numVertCellsVisible = (work / (cellHeight + horizontalGridLineWidth))+1;
}

//////////////////////////////////////
// given an index, return its top left
//////////////////////////////////////
- (CGPoint) calcCellPosition:(NSIndexPath*) indexPath
{
	CGPoint result;
	
	result.x = borderGridLineWidth + ((verticalGridLineWidth + cellWidth) * [indexPath column]);
	result.y = borderGridLineWidth + ((horizontalGridLineWidth + cellHeight) * [indexPath row]);
	if (headerView)
	{
		result.y += headerView.bounds.size.height;
	}
	
	return result;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)layoutSubviews
{
	
	if (!initialSetupDone)
	{
		[self setup];
		initialSetupDone = YES;
	}

	[self calcGeometry];
	
	NSUInteger indicies[2];
	CGRect workingCells;
	UIXGridViewCell* cell;
	
	CGPoint currPos = self.contentOffset;
	CGPoint topLeftCell;
	
	topLeftCell.x = floor(currPos.x / cellWidth);   //!!!
	topLeftCell.y = floor(currPos.y / cellHeight);
	
	topLeftCell.x = (topLeftCell.x >= 0) ? topLeftCell.x : 0;
	topLeftCell.y = (topLeftCell.x >= 0) ? topLeftCell.y : 0;
	
	workingCells.origin = topLeftCell;
	if (workingCells.origin.y + numVertCellsVisible+ 1 > rows)
		workingCells.size.height = rows - workingCells.origin.y; 
	else	
		workingCells.size.height = numVertCellsVisible+1; 
	
	if (workingCells.origin.x + numHorzCellsVisible+ 1 > columns)
		workingCells.size.width = columns - workingCells.origin.x; 
	else	
		workingCells.size.width = numHorzCellsVisible+1; 
	
	if (CGRectEqualToRect( workingCells, currentlyDisplayedCells) && !hasNewData)
	{
		return; //bail if nothing changed
	}
	
	CGRect frame = self.frame;
	
	CGFloat baseY = 0;

	if (headerView)
	{
		baseY = headerView.bounds.size.height;
		frame = headerView.frame;
		frame.size.width = contentSize.width;
		headerView.frame = frame;
		contentSize.height += frame.size.height;
	}
		
	if (footerView)
	{
		frame = footerView.frame;
		frame.size.width = contentSize.width;
		footerView.frame = frame;
		contentSize.height += frame.size.height;
	}
		
	
	//clear out the old
	for (NSIndexPath* ip in [cells allKeys])
	{
		CGPoint p = CGPointMake([ip column], [ip row]);
		if (!CGRectContainsPoint(workingCells, p) || hasNewData)
		{
			cell = (UIXGridViewCell*)[cells objectForKey:ip];
			[cell prepareForReuse];
			[self enqueueCell:cell];
			
			NSArray* a = [cells allKeysForObject:cell];
			for (NSIndexPath* ip in a)
			{
				[cells removeObjectForKey:ip];
			}
			
			[cell removeFromSuperview];
		}
	}

	//add the new
	for (NSInteger r = workingCells.origin.y; r < workingCells.origin.y + workingCells.size.height; r++)
	{
		for (NSInteger c = workingCells.origin.x; c < workingCells.origin.x + workingCells.size.width; c++)
		{
			indicies[0] = c; indicies[1] = r;
			NSIndexPath* ip = [NSIndexPath indexPathWithIndexes:indicies length:2];
			
			UIView* v = [cells objectForKey:ip];
			if (v == nil)
			{
				cell = [self.dataSource UIXGridView:self cellForIndexPath:ip];   
				if (cell != nil)
				{
					[cells setObject:cell forKey:ip];

					frame.origin = [self calcCellPosition:(NSIndexPath*) ip];
					frame.size.width = cellWidth;
					frame.size.height = cellHeight;
					
					cell.frame = frame;
					if ([selectionIndexPaths containsObject:ip])
					{
						cell.selected = YES;
					}
					
					//NSLog(@"cell ip=%@ rect=%@ cell=%@ selected=%d",ip,NSStringFromCGRect(frame),cell,cell.isSelected);
					[self addSubview:cell];
				}	
			}
		}//end for
	}//end for
	
	currentlyDisplayedCells = workingCells;
	
	if (footerView)
	{
		frame = footerView.frame;
		
		frame.origin.y = baseY+(cellHeight * rows);
		footerView.frame = frame;
	}
		
	self.contentSize = contentSize;	

	[super layoutSubviews];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) callDidSelectDelegateForIndexPath:(NSIndexPath*) path
{
	[selectionIndexPaths addObject:path];
	if (self.delegate != nil)
	{
		if ([self.delegate respondsToSelector:@selector(UIXGridView:didSelectCellForIndexPath:)])
		{
			[self.delegate UIXGridView: self didSelectCellForIndexPath: path];
		}
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) callWillSelectDelegateForIndexPath:(NSIndexPath*) indexPath
{
	if (self.delegate != nil)
	{
		if ([self.delegate respondsToSelector:@selector(UIXGridView:willSelectCellForIndexPath:)])
		{
			[self.delegate UIXGridView: self willSelectCellForIndexPath: indexPath];
		}
	}
}
//////////////////////////////////////
//
//////////////////////////////////////
- (void) callDidDeselectDelegateForIndexPath:(NSIndexPath*) path
{
	[selectionIndexPaths removeObject:path];

	if (self.delegate != nil)
	{
		if ([self.delegate respondsToSelector:@selector(UIXGridView:didDeselectCellForIndexPath:)])
		{
			[self.delegate UIXGridView: self didDeselectCellForIndexPath: path];
		}
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) callWillDeselectDelegateForIndexPath:(NSIndexPath*) indexPath
{
	if (self.delegate != nil)
	{
		if ([self.delegate respondsToSelector:@selector(UIXGridView:willDeselectCellForIndexPath:)])
		{
			[self.delegate UIXGridView: self willDeselectCellForIndexPath: indexPath];
		}
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (BOOL) callShouldSelectDelegateForIndexPath:(NSIndexPath*) indexPath
{
	BOOL result = YES;
	
	if (self.delegate != nil)
	{
		if ([self.delegate respondsToSelector:@selector(UIXGridView:shouldSelectCellForIndexPath:)])
		{
			result = [self.delegate UIXGridView: self shouldSelectCellForIndexPath: indexPath];
		}
	}
	
	return result;
}

#if 0
//////////////////////////////////////
//
//////////////////////////////////////
- (CGRect) selectionRect:(NSIndexPath*) path
{
	CGRect frame;
	
	frame.origin.x = (cellWidth * [path column]) + cellInsets.left;
	frame.origin.y = (cellHeight * [path row]) + cellInsets.top;
	frame.size.width = cellWidth - (cellInsets.left + cellInsets.right);
	frame.size.height = cellHeight - (cellInsets.top + cellInsets.bottom);
	
	return frame;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (CGRect) cellRect:(NSIndexPath*) path
{
	CGRect frame;
	
	frame.origin.x = (cellWidth * [path column]);
	frame.origin.y = (cellHeight * [path row]);
	frame.size.width = cellWidth;
	frame.size.height = cellHeight;
	
	return frame;
}
#endif

//////////////////////////////////////
//
//////////////////////////////////////
- (void) cellTouched:(UIXGridViewCell*) cell
{
	if (selectionType == UIXGridViewSelectionType_Momentary)
	{
		[self selectCell:cell];
	}
}


//////////////////////////////////////
//
//////////////////////////////////////
- (void) cellReleased:(UIXGridViewCell*) cell
{
	if (selectionType == UIXGridViewSelectionType_Momentary)
	{
		//[self setNeedsDisplayInRect:[self cellRect]];
		cell.selected = NO;
		
		if ([self cellIsSelected:cell])
		{
			NSIndexPath* indexPath = [[cells allKeysForObject:cell] objectAtIndex:0];
			[self callDidSelectDelegateForIndexPath: indexPath];
			[self clearSelection];
			[self setNeedsDisplay];
		}
	}
	else
	{
		[self selectCell:cell];
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) cellTouchMoved:(UIXGridViewCell*) cell withEvent:(UIEvent*) event
{
	if (selectionType == UIXGridViewSelectionType_Momentary)
	{
		UITouch* touch;
		CGPoint p;
		
		if ([[event allTouches] count] == 1)
		{
			//NSLog(@"touch moved : %X",self);
			touch = [[event allTouches] anyObject];
			p = [touch locationInView:cell];
			
			BOOL inside = [cell pointInside:p withEvent:event];
			//NSLog(@"x=%f y=%f inside=%d",p.x,p.y,inside);

			if (!inside)
			{
				[self deselectCell:cell];
			}
			else
			{
				[self selectCell:cell];
			}
		}	
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) deselectCellAtIndexPath:(NSIndexPath*) indexPath
{
	UIXGridViewCell* cell = [self cellAtIndexPath:indexPath];
	
	if (cell != nil)
	{
		[self callWillDeselectDelegateForIndexPath:indexPath];
		cell.selected = NO;
		[self callDidDeselectDelegateForIndexPath:indexPath];
		[cell setNeedsDisplay];
	}
	
	[selectionIndexPaths removeObject:indexPath];

	[self setNeedsDisplay];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) deselectCell:(UIXGridViewCell*) cell
{
	NSArray* arr = [cells allKeysForObject:cell];
	
	NSIndexPath* indexPath = [arr objectAtIndex:0];

	[self deselectCellAtIndexPath:indexPath];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) selectCellAtIndexPath:(NSIndexPath*) indexPath
{
	UIXGridViewCell* cell = [self cellAtIndexPath:indexPath];
	
	if (cell != nil)
	{
		[self callWillSelectDelegateForIndexPath:indexPath];
		cell.selected = YES;
		[self callDidSelectDelegateForIndexPath:indexPath];
		[cell setNeedsDisplay];
	}
	
	[selectionIndexPaths addObject:indexPath];
	
	[self setNeedsDisplay];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) selectCell:(UIXGridViewCell*) cell
{
	NSArray* keys;
	//CGRect frame;
	
	//NSLog(@"select cell: %@", cell);

	//find its postion
	keys = [cells allKeysForObject:cell];
	if ([keys count] == 1)
	{
		NSIndexPath* path = [keys objectAtIndex:0];

		switch (selectionType)
		{
			case UIXGridViewSelectionType_Momentary:
			{
				//set selected but do not call selected (that happens and up)
				if ([self callShouldSelectDelegateForIndexPath: path])
				{	
					[self callWillSelectDelegateForIndexPath:path];
					[selectionIndexPaths addObject:path];
					cell.selected = YES;
					[self setNeedsDisplay];
				}
			}
				break;
				
			case UIXGridViewSelectionType_Single:
			{
				if (!cell.isSelected)
				{
					if ([self callShouldSelectDelegateForIndexPath: path])
					{	
						[self clearSelection];
						[selectionIndexPaths addObject:path];
						cell.selected = YES;
						[self callDidSelectDelegateForIndexPath: path];
					}
				
					[self setNeedsDisplay];
				}
			}
				break;
				
			case UIXGridViewSelectionType_Multiple:
			{
				if ([self cellIsSelected:cell])
				{
					[self deselectCellAtIndexPath:path];
				}
				else 
				{
					if ([self callShouldSelectDelegateForIndexPath:path])
					{
						[self callWillSelectDelegateForIndexPath: path];
						cell.selected = YES;
						[self setNeedsDisplay];
						[self callDidSelectDelegateForIndexPath: path];
					}	
				}

				//else
			}
				break;
		}
	}
	else
	{
		//!!!exception, things be fucked up
	}
	
	//save its pos a s saved
	//save cell?
}


/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}


//////////////////////////////////////
//
//////////////////////////////////////
- (void)drawRectSelectionForCell:(UIXGridViewCell*) cell
{
	CGRect frame = cell.frame;
	CGContextRef context = UIGraphicsGetCurrentContext();
		
	CGContextSetFillColorWithColor(context, selectionColor.CGColor);
	CGContextFillRect(context, frame);
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)drawRoundRectSelectionForCell:(UIXGridViewCell*) cell
{
	CGRect frame;
	
	frame = cell.frame;
	frame = CGRectInset(frame, 1, 1);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, 1);
	
	[selectionColor set];
	
	CGContextSetFillColorWithColor(context, selectionColor.CGColor);
	
	///////////////////
	CGFloat corner_radius = 7;
	CGFloat x_left = frame.origin.x;  
	CGFloat x_left_center = frame.origin.x + corner_radius;  
	CGFloat x_right_center = frame.origin.x + frame.size.width - corner_radius;  
	CGFloat x_right = frame.origin.x + frame.size.width;  
	CGFloat y_top = frame.origin.y;  
	CGFloat y_top_center = frame.origin.y + corner_radius;  
	CGFloat y_bottom_center = frame.origin.y + frame.size.height - corner_radius;  
	CGFloat y_bottom = frame.origin.y + frame.size.height;  
	
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
	
	CGRect pathBox = CGContextGetPathBoundingBox (context);	
	CGContextDrawPath(context, kCGPathFillStroke);			
	///////////////////
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)drawGridLines
{
	CGRect frame;
	CGPoint start, end;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[gridLineColor set];
	CGContextBeginPath(context);  
	
	//border
	if (borderGridLineWidth)
	{
		CGFloat insetAdjust = borderGridLineWidth/2; 
		CGContextSetLineWidth(context, borderGridLineWidth);
		frame.origin.x = insetAdjust;
		frame.origin.y = insetAdjust;
		frame.size.width = contentSize.width-borderGridLineWidth;
		frame.size.height = contentSize.height-borderGridLineWidth;
		CGContextAddRect (context,frame);
	}
	
	if (horizontalGridLineWidth)
	{
		for (CGFloat ndx = 1.0; ndx < (rows); ++ndx)
		{
			start.x = borderGridLineWidth;
			end.x = contentSize.width - borderGridLineWidth;
			start.y = end.y = (borderGridLineWidth + (cellHeight * ndx) + (horizontalGridLineWidth * ndx)) - (horizontalGridLineWidth/2);
			CGContextMoveToPoint(context, start.x, start.y);
			CGContextAddLineToPoint(context, end.x, end.y);
		}	
	}
	
	if (verticalGridLineWidth)
	{
		for (CGFloat ndx = 1.0; ndx < (columns); ++ndx)
		{
			start.y = borderGridLineWidth;
			end.y = contentSize.height - borderGridLineWidth;
			start.x = end.x = (borderGridLineWidth + (cellWidth * ndx) + (verticalGridLineWidth * ndx)) - (verticalGridLineWidth/2);
			CGContextMoveToPoint(context, start.x, start.y);
			CGContextAddLineToPoint(context, end.x, end.y);
		}	
	}
	
	CGContextClosePath(context);  
	CGContextDrawPath(context, kCGPathStroke);			
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)drawRect:(CGRect)rect
{	
	NSIndexPath* indexPath;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
	CGContextFillRect(context,rect);
	[self drawGridLines];
		
	UIXGridViewCellSelectionStyle selectionStyle = 	UIXGridViewCellSelectionStyleRoundRect;
	
	for (UIXGridViewCell* cell in [cells allValues])
	{
		if (cell.isSelected)
		{
			//NSLog(@"cell is selected:%@",cell);
			indexPath = [[cells allKeysForObject:cell] objectAtIndex:0];
				
			if ([self.delegate respondsToSelector:@selector(UIXGridView:selectionStyleForCellAtIndexPath:)])
			{
				selectionStyle = [self.delegate UIXGridView: self  selectionStyleForCellAtIndexPath: indexPath];
			}
			
			//!!!validate style
			if (selectionStyle != UIXGridViewCellSelectionStyleNone)
			{
				switch (selectionStyle)
				{
					case UIXGridViewCellSelectionStyleRect:
					{
						[self drawRectSelectionForCell:cell];
					}
						break;
						
					case UIXGridViewCellSelectionStyleRoundRect:
					{
						[self drawRoundRectSelectionForCell:cell];
					}
						break;
				}
			}
		}
	}
	[super drawRect:rect];
}

/////////////////////////////////////////////
//
/////////////////////////////////////////////
//- (NSArray*) selectedCells
//{
//	NSMutableArray* arr = [NSMutableArray array];
//	
//	for (UIXGridViewCell* cell in [cells allValues])
//	{
//		if (cell.selected)
//		{
//			[arr addObject:cell];
//		}
//	}
//	
//	return arr;
//}

///////////////////////////////////////////////////////////////////////////////	
///////////////////////////////////////////////////////////////////////////////	
// External methods
///////////////////////////////////////////////////////////////////////////////	
///////////////////////////////////////////////////////////////////////////////	

//////////////////////////////////////
//
//////////////////////////////////////
- (BOOL) cellIsSelected:(UIXGridViewCell*) cell
{
	NSIndexPath* indexPath = [[cells allKeysForObject:cell] objectAtIndex:0];
	return [selectionIndexPaths containsObject:indexPath];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (BOOL) indexPathIsSelected:(NSIndexPath*) path
{
	return [selectionIndexPaths containsObject:path];
}

/////////////////////////////////////////////
//
/////////////////////////////////////////////
//- (NSArray*) selectedCells
//{
//	NSMutableArray* arr = [NSMutableArray array];
//	
//	for (UIXGridViewCell* cell in [cells allValues])
//	{
//		if (cell.selected)
//		{
//			[arr addObject:cell];
//		}
//	}
//	
//	return arr;
//}

///////////////////////////////////////////////////////////////////////////////	
///////////////////////////////////////////////////////////////////////////////	
// External methods
///////////////////////////////////////////////////////////////////////////////	
///////////////////////////////////////////////////////////////////////////////	

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (void) setHeaderView: (UIView*) view
{
	CGFloat change;
	CGRect frame;
	CGSize size = CGSizeMake(0,0);
	
	if (!headerView && !view)
	{
		return;
	}
	
	if (view)
	{	
		if (headerView)
		{	
			change = view.bounds.size.height;
			change -= headerView.bounds.size.height; 
		}
		else
		{
			change = view.bounds.size.height;
		}
	}
	else
	{
		change = -(headerView.bounds.size.height);
	}
	
	//adjust content size
	size = self.contentSize;
	size.height += change;
	self.contentSize = size;

	//adjust all cells and footer if present
	for (UIXGridViewCell* cell in [cells allValues])
	{
		frame = cell.frame;
		frame.origin.x += change;
		cell.frame = frame;
	}
	
	if (footerView)
	{
		frame = footerView.frame;
		frame.origin.x += change;
		footerView.frame = frame;
	}
	
	//disconnect the old
	[headerView release];
	[headerView removeFromSuperview];
	headerView = [view retain];
	
	if (view)
	{
		frame = view.bounds;
		frame.origin.x = frame.origin.y = 0;
		frame.size.width = self.contentSize.width;
		view.frame = frame;
		//attach the new
		[self addSubview:view];
	}	
}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (void) setFooterView: (UIView*) view
{
	CGFloat change;
	CGRect frame;
	CGSize size = CGSizeMake(0,0);
	
	if (!footerView && !view)
	{
		return;
	}
	
	if (view)
	{	
		if (footerView)
		{	
			change = view.bounds.size.height;
			change -= footerView.bounds.size.height; 
		}
		else
		{
			change = view.bounds.size.height;
		}
	}
	else
	{
		change = -(footerView.bounds.size.height);
	}
	
	//adjust content size
	size = self.contentSize;
	size.height += change;
	self.contentSize = size;

	//disconnect the old
	[footerView release];
	[footerView removeFromSuperview];
	footerView = [view retain];
	
	if (view)
	{
		frame = view.bounds;
		frame.origin.x = 0;
		frame.origin.y = size.height - frame.size.height;
		frame.size.width = self.contentSize.width;
		view.frame = frame;
		//attach the new
		[self addSubview:view];
	}	
}


/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (UIXGridViewCell*)dequeueReusableCellWithIdentifier:(NSString*) reuseId
{
	NSMutableArray* arr;
	UIXGridViewCell* cell = nil;
	
	arr = [reusableCells objectForKey:reuseId];
	if (arr != nil)
	{
		if ([arr count] > 0)
		{
			cell = [arr objectAtIndex:0];
			[arr removeObjectAtIndex:0];
		}
		
	}
	
	return cell;
}

/////////////////////////////////////////////////
// returns cell for the index path or nil if it is not
// visible or does not exist
/////////////////////////////////////////////////
- (UIXGridViewCell*) cellAtIndexPath:(NSIndexPath*) path
{
	UIXGridViewCell* result = nil;
	
	result = [cells objectForKey:path];
	
	return result;
}


/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (NSArray*) visibleCells
{
	return [cells allValues];
}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (NSArray*) selection
{
	return [selectionIndexPaths allObjects];
}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (NSArray*) selectedCellsIndexPaths
{
	NSMutableArray* arr = [NSMutableArray array];
	
	for (UIXGridViewCell* cell in [cells allValues])
	{
		if (cell.isSelected)
		{
			NSArray* keys = [cells allKeysForObject:cell];
			for (NSIndexPath* ip in keys)
			{
				[arr addObject:ip];
			}
		}
	}
	
	return arr;
}

/////////////////////////////////////////////////
// returns the visible selected cells
/////////////////////////////////////////////////
- (NSArray*) selectedCells
{
	NSMutableArray* result = [NSMutableArray array];
	
	for (UIXGridViewCell* cell in [cells allValues])
	{
		if (cell.isSelected)
		{
			[result addObject:cell];
		}
	}
	
	return result;
}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (void) clearSelection
{
	while ([selectionIndexPaths count] > 0)
	{
		[self deselectCellAtIndexPath:[[selectionIndexPaths allObjects] objectAtIndex:0]];
	}
}

@end

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
@implementation NSIndexPath (UIXGridView)

@dynamic column;
@dynamic row;

+ (NSIndexPath *)indexPathForRow:(NSUInteger)row inColumn:(NSUInteger)column
{
	NSUInteger ndx[2] = {column, row}; 
	return [NSIndexPath indexPathWithIndexes:ndx length:2];
}

- (NSUInteger) column
{
	return [self indexAtPosition:0];
}

- (NSUInteger) row
{
	return [self indexAtPosition:1];
}

@end
