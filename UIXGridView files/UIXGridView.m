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
@synthesize columnWidth;
@synthesize rowHeight;
@synthesize cellInsets;
@synthesize style;
@synthesize selectionType;
@synthesize selectionColor;
@synthesize selectedCell;
@synthesize headerView;
@synthesize footerView;

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
	
	cellInsets.top = cellInsets.right = cellInsets.bottom = cellInsets.left = 3;
	
	selectedCell = nil;
	selectedCellPath = nil;
	self.contentMode = UIViewContentModeRedraw;

	switch (style)
	{
		case UIXGridViewStyle_Constrained:
		if (!initialSetupDone)
		{
			columns = [self.dataSource numberOfColumnsForGrid:self];
			rows = [self.dataSource numberOfRowsForGrid:self];			
		}
			break;
		
		case UIXGridViewStyle_HorzConstrained:
		{
			columns = [self.dataSource numberOfColumnsForGrid:self];
			rowHeight = [self.dataSource cellHeightForGrid:self];  
		}
			break;
			
		case UIXGridViewStyle_VertConstrained:
		{
			rows = [self.dataSource numberOfRowsForGrid:self];			
			columnWidth = [self.dataSource cellWidthForGrid:self];  
		}
			break;
			
		case UIXGridViewStyle_Unconstrained:
		{
			columnWidth = [self.dataSource cellWidthForGrid:self];  
			rowHeight = [self.dataSource cellHeightForGrid:self]; 
		}
			break;
	}
	
	CGRect frame = self.frame;

	if (style == UIXGridViewStyle_Constrained || style == UIXGridViewStyle_HorzConstrained)
	{
		columnWidth = frame.size.width / columns;
	}
	
	if (style == UIXGridViewStyle_Constrained || style == UIXGridViewStyle_VertConstrained)
	{
		rowHeight = frame.size.height / rows;
	}
	
	cellWidth = columnWidth - (cellInsets.left + cellInsets.right);
	cellHeight = rowHeight - (cellInsets.top + cellInsets.bottom);
	
	numHorzCellsVisible = frame.size.width / cellWidth;
	numVertCellsVisible = frame.size.height / cellHeight;

	
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
		cellQueue = [[NSMutableArray array] retain];
		cells = [[NSMutableDictionary dictionary] retain];
		//[self setup];
	}
	
	return self;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) reloadData
{
	CGRect frame = self.frame;

	switch (style)
	{
		case UIXGridViewStyle_Constrained:
			if (!initialSetupDone)
			{
				columns = [self.dataSource numberOfColumnsForGrid:self];
				rows = [self.dataSource numberOfRowsForGrid:self];			
				contentSize = CGSizeMake(frame.size.width,frame.size.height);
			}
			break;
			
		case UIXGridViewStyle_HorzConstrained:
		{
			rows = [self.dataSource numberOfRowsForGrid:self];			
			rowHeight = [self.dataSource cellHeightForGrid:self];  //??
			contentSize = CGSizeMake(frame.size.width, rows * rowHeight);
		}
			break;
			
		case UIXGridViewStyle_VertConstrained:
		{
			columns = [self.dataSource numberOfColumnsForGrid:self];
			columnWidth = [self.dataSource cellWidthForGrid:self];   //??
			contentSize = CGSizeMake(columns * columnWidth, frame.size.height);
		}
			break;
			
		case UIXGridViewStyle_Unconstrained:
		{
			columns = [self.dataSource numberOfColumnsForGrid:self];
			rows = [self.dataSource numberOfRowsForGrid:self];			
			columnWidth = [self.dataSource cellWidthForGrid:self];  //??
			rowHeight = [self.dataSource cellHeightForGrid:self]; //??
			contentSize = CGSizeMake(columns * columnWidth,  rows * rowHeight);
		}
			break;
	}

	
	
	hasNewData = YES;
	[self setNeedsLayout];
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

	NSUInteger indicies[2];
	CGRect workingCells;
	UIXGridViewCell* cell;
	
	CGPoint currPos = self.contentOffset;
	CGPoint topLeftCell;
	
	topLeftCell.x = floor(currPos.x / columnWidth);
	topLeftCell.y = floor(currPos.y / rowHeight);
	
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
	
	if (CGRectEqualToRect( workingCells, currentlyDisplayedCells))
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
		if (!CGRectContainsPoint(workingCells, p))
		{
			UIXGridViewCell* v = (UIXGridViewCell*)[cells objectForKey:ip];
			[v prepareForReuse];
			[cellQueue addObject:v]; 
			
			NSArray* a = [cells allKeysForObject:v];
			for (NSIndexPath* ip in a)
			{
				[cells removeObjectForKey:ip];
			}
			
			[v removeFromSuperview];
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

					frame.origin.x = (columnWidth * c) + cellInsets.left;
					frame.origin.y = (rowHeight * r) + cellInsets.top + baseY;
					frame.size.width = cellWidth;
					frame.size.height = cellHeight;
					
					cell.frame = frame;
					[self addSubview:cell];
				}	
			}
		}//end for
	}//end for
	
	currentlyDisplayedCells = workingCells;
	
	if (footerView)
	{
		frame = footerView.frame;
		
		frame.origin.y = baseY+(rowHeight * rows);
		footerView.frame = frame;
	}
		
	self.contentSize = contentSize;	

	[super layoutSubviews];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) callDidSelectDelegate
{
	if (self.delegate != nil)
	{
		if ([self.delegate respondsToSelector:@selector(UIXGridView:didSelectCellForIndexPath:)])
		{
			[selectionIndexPaths addObject:selectedCellPath];
			[self.delegate UIXGridView: self didSelectCellForIndexPath: selectedCellPath];
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
- (void) callDidDeselectDelegate
{
	if (self.delegate != nil)
	{
		if ([self.delegate respondsToSelector:@selector(UIXGridView:didDeselectCellForIndexPath:)])
		{
			[selectionIndexPaths removeObject:selectedCellPath];
			[self.delegate UIXGridView: self didDeselectCellForIndexPath: selectedCellPath];
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


//////////////////////////////////////
//
//////////////////////////////////////
- (CGRect) selectionRect
{
	CGRect frame;
	
	frame.origin.x = (columnWidth * [selectedCellPath column]) + cellInsets.left;
	frame.origin.y = (rowHeight * [selectedCellPath row]) + cellInsets.top;
	frame.size.width = columnWidth - (cellInsets.left + cellInsets.right);
	frame.size.height = rowHeight - (cellInsets.top + cellInsets.bottom);
	
	return frame;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (CGRect) cellRect
{
	CGRect frame;
	
	frame.origin.x = (columnWidth * [selectedCellPath column]);
	frame.origin.y = (rowHeight * [selectedCellPath row]);
	frame.size.width = columnWidth;
	frame.size.height = rowHeight;
	
	return frame;
}

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
		[cell setNeedsDisplay];
		if (cell == selectedCell)
		{
			[self callDidSelectDelegate];
		}
		selectedCell = nil;
		selectedCellPath = nil;
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
			NSLog(@"touch moved : %X",self);
			touch = [[event allTouches] anyObject];
			p = [touch locationInView:cell];
			
			BOOL inside = [cell pointInside:p withEvent:event];
			NSLog(@"x=%f y=%f inside=%d",p.x,p.y,inside);
			//UIXGridView* grid = (UIXGridView*) self.superview;
			if (!inside)
			{
				//[grid cellReleased:self];
				[self deselectCell:cell];
			}
			else
			{
				//[grid cellTouched:self];
				[self selectCell:cell];
			}
		}	
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) deselectCell:(UIXGridViewCell*) cell
{
	cell.selected = NO;
	selectedCell = nil;
	selectedCellPath = nil;
	[cell setNeedsDisplay];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) selectCell:(UIXGridViewCell*) cell
{
	NSArray* keys;
	CGRect frame;
	
	//find its postion
	keys = [cells allKeysForObject:cell];
	if ([keys count] == 1)
	{
		if (selectionType != UIXGridViewSelectionType_Momentary)
		{	
			if (![self callShouldSelectDelegateForIndexPath:[keys objectAtIndex:0]])
			{	
				return;
			}
		}
		
		if ((selectionType == UIXGridViewSelectionType_Multiple) && cell.selected) //deselect 
		{
			[self deselectCell:cell];
		}
		else
		{
			if ((selectionType != UIXGridViewSelectionType_Multiple) && selectedCell != nil)
			{
				[self deselectCell: selectedCell];
			}
		
			if (selectionType != UIXGridViewSelectionType_Momentary)
			{
				[self callWillSelectDelegateForIndexPath:[keys objectAtIndex:0]];
			}	
			selectedCell = cell;
			cell.selected = YES;
			selectedCellPath = [keys objectAtIndex:0];

			frame = [self cellRect];
			[selectedCell setNeedsDisplay];

			if (selectionType != UIXGridViewSelectionType_Momentary)
			{
				[self callDidSelectDelegate];
			}
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
- (NSArray*) selectedCellsIndexPaths
{
	NSMutableArray* arr = [NSMutableArray array];
	
	for (UIXGridViewCell* cell in [cells allValues])
	{
		if (cell.selected)
		{
			NSArray* keys = [cells allKeysForObject:cell];
			for (NSIndexPath* ip in keys)
			{
				[arr addObject:cell];
			}
		}
	}

	return arr;
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (UIXGridViewCell*)dequeueReusableCell
{
	if ([cellQueue count] == 0)
	{
		return nil;
	}
	else
	{
		UIXGridViewCell* cell = [cellQueue objectAtIndex:0];
		[cellQueue removeObjectAtIndex:0];
		return cell;
	}
	
	return nil;
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
// returns the visible selected cells
/////////////////////////////////////////////////
- (NSArray*) selectedCells
{
	//iterate and get cells that are selected
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
