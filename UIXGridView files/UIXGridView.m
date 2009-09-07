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
//@synthesize momentary;
//@synthesize multiSelect;
@synthesize selectedCell;
@synthesize headerView;
@synthesize footerView;

//////////////////////////////////////
//
//////////////////////////////////////
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) setup
{
	[self setNeedsLayout];
	constrainHorzToScreenSize = YES;
	constrainVertToScreenSize = YES;
	
	columns = 0;
	rows = 0;
	
	hasNewData = YES;
	cells = [[NSMutableDictionary dictionary] retain];
	
	cellInsets.top = cellInsets.right = cellInsets.bottom = cellInsets.left = 3;
	
	selectedCell = nil;
	selectedCellPath = nil;
	self.selectionColor = [UIColor purpleColor];
	self.contentMode = UIViewContentModeRedraw;
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
- (void)viewDidLoad 
{
}

//////////////////////////////////////
//
//////////////////////////////////////
//- (void) awakeFromNib
//{
//	[self setup];
//}

//////////////////////////////////////
//
//////////////////////////////////////
- (id)initWithFrame:(CGRect) frame andStyle:(NSInteger) s selectionType:(NSInteger) selType
{
	
	if (self = [super initWithFrame:frame])
	{
		style = s;
		selectionType = selType;
		
		[self setup];
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
- (void)layoutSubviews
{
	NSUInteger indicies[2];
	CGRect frame = self.frame;
	UIXGridViewCell* cell;

	CGSize contentSize;
	
	CGFloat baseY = 0;
	if (headerView)
	{
		baseY = headerView.bounds.size.height;
	}
	
	if (hasNewData)
	{	
		
		for (UIView* v in self.subviews)
		{
			if (v != headerView && v != footerView)
			{
				[v removeFromSuperview];
			}	
		}
		
		columns = [self.dataSource numberOfColumnsForGrid:self];
		rows = [self.dataSource numberOfRowsForGrid:self];

		switch (style)
		{
			case UIXGridViewStyle_Constrained:
				contentSize = CGSizeMake(frame.size.width,frame.size.height);
				break;
			
			case UIXGridViewStyle_HorzConstrained:
				rowHeight = [self.dataSource cellHeightForGrid:self];
				contentSize = CGSizeMake(frame.size.width, rows * rowHeight);
				break;
			
			case UIXGridViewStyle_VertConstrained:
				columnWidth = [self.dataSource cellWidthForGrid:self];
				contentSize = CGSizeMake(columns * columnWidth, frame.size.height);
				break;
			
			case UIXGridViewStyle_Unconstrained:
				columnWidth = [self.dataSource cellWidthForGrid:self];
				rowHeight = [self.dataSource cellHeightForGrid:self];
				contentSize = CGSizeMake(columns * columnWidth,  rows * rowHeight);
				break;
		}
	
		if (headerView)
		{
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
	
		[cells removeAllObjects];

		//iterate over and get cells
		for (NSInteger c=0; c < columns; c++)
		{
			for (NSInteger r=0; r < rows; r++)
			{
				indicies[0] = c; indicies[1] = r;
				NSIndexPath* ip = [NSIndexPath indexPathWithIndexes:indicies length:2];
			
				cell = [self.dataSource UIXGridView:self cellForIndexPath:ip];
				if (cell != nil)
				{
					[cells setObject:cell forKey:ip];
					//if (cell.selected && !multiSelect && !momentary)
					if (cell.selected && (selectionType == UIXGridViewSelectionType_Single))
					{
						selectedCellPath = ip;
						selectedCell = cell;
					}
			
					frame.origin.x = (columnWidth * c) + cellInsets.left;
					frame.origin.y = (rowHeight * r) + cellInsets.top + baseY;
					frame.size.width = cellWidth;
					frame.size.height = cellHeight;
			
					cell.frame = frame;
					[self addSubview:cell];
				}//endif	
			}//endfor
		}//endfor
	
		if (footerView)
		{
			frame = footerView.frame;
		
			frame.origin.y = baseY+(rowHeight * rows);
			footerView.frame = frame;
		}
		
		self.contentSize = contentSize;	
		
		hasNewData = NO;
	}
	
	[self setNeedsDisplay];
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

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (NSArray*) selectedCells
{
	NSMutableArray* arr = [NSMutableArray array];
	
	for (UIXGridViewCell* cell in [cells allValues])
	{
		if (cell.selected)
		{
			[arr addObject:cell];
		}
	}
	
	return arr;
}

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
