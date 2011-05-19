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
#import "UIXGridViewSpanningCell.h"

@implementation UIXGridView

@synthesize dataSource;
@synthesize gridDelegate;

@synthesize columns;
@synthesize rows;
@synthesize constrainHorzToScreenSize;
@synthesize constrainVertToScreenSize;
@synthesize customSelect;
@synthesize cellInsets;
@synthesize style;
//@synthesize selectionColor;
@synthesize headerView;
@synthesize footerView;

@synthesize horizontalGridLineWidth;
@synthesize verticalGridLineWidth;
@synthesize borderGridLineWidth;
@synthesize gridLineColor;

@synthesize cellWidth;
@synthesize cellHeight;

@synthesize gridStyle;
@synthesize selectionStyle;

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
	spannedCells = [[NSMutableDictionary dictionary] retain];
    
    calculateGeometryOnLayout = YES;
    initialSetupDone = YES;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (BOOL) touchesShouldCancelInContentView:(UIView*) view
{
	return YES;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (id)initWithFrame:(CGRect) frame 
           andStyle:(UIXGridViewStyle) s 
      selectionType:(UIXGridViewSelectionStyle) selectionType
{
	
	if ((self = [super initWithFrame:frame]))
	{
		style = s;
        gridStyle = s;
        selectionStyle = selectionType;
        
		initialSetupDone = NO;
        
		super.delegate = self;
        
        [self setup];
//		self.selectionColor = [UIColor blueColor];
	}
	
	return self;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (id)initWithFrame:(CGRect) frame andStyle:(UIXGridViewStyle) s
{
    return [self initWithFrame:frame 
                      andStyle:s
                 selectionType:UIXGridViewSelectionStyleSingle];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) dealloc
{
//	self.selectionColor = nil;	
	self.headerView = nil;
	self.footerView = nil;
	self.gridLineColor = nil;

	[cells release];
	[selectionIndexPaths release];
	[cellQueue release];
	[reusableCells release];
	[spannedCells release];
	
	[super dealloc];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) reloadData
{
    calculateGeometryOnLayout = YES;
	hasNewData = YES;
	[self layoutSubviews];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) enqueueCell:(UIXGridViewCell*) cell
{
//	NSLog(@"cell enqueued: %08X",cell);

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
// determine the cell geometries
//
//////////////////////////////////////
- (void) calcGeometry
{
	switch (style)
	{
		case UIXGridViewStyleConstrained:
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
			
		case UIXGridViewStyleHorzConstrained:
		{
			//set rows cols
			columns = [self.dataSource numberOfColumnsForGrid:self];
			rows = [self.dataSource numberOfRowsForGrid:self];
			
			contentSize.width = self.frame.size.width;
			cellWidth = (contentSize.width - ((borderGridLineWidth * 2) + (verticalGridLineWidth * (columns - 1)))) / columns;
			
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
			
		case UIXGridViewStyleVertConstrained:
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
			
		case UIXGridViewStyleUnconstrained:
		{
			columns = [self.dataSource numberOfColumnsForGrid:self];
			rows = [self.dataSource numberOfRowsForGrid:self];
			
			cellWidth = [self.dataSource cellWidthForGrid:self];
			cellHeight = [self.dataSource cellHeightForGrid:self];
			
			contentSize.height = (borderGridLineWidth * 2) + 
					(horizontalGridLineWidth * (rows-1)) + 
					(cellHeight * rows);

			contentSize.width = (borderGridLineWidth * 2) + 
					(verticalGridLineWidth * (columns-1)) + 
					(cellWidth * columns);
		}
			break;
	}
	
	CGFloat work = self.frame.size.width - (borderGridLineWidth * 2);
	work -= cellWidth;
	numHorzCellsVisible = (work / (cellWidth + verticalGridLineWidth))+1;
	
	
	work = self.frame.size.height - (borderGridLineWidth * 2);
	work -= cellHeight;
	numVertCellsVisible = (work / (cellHeight + horizontalGridLineWidth))+1;
    
    calculateGeometryOnLayout = NO;
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
- (void) clearSpanned:(UIXGridViewSpanningCell*) spanningCell
{
	NSArray* keys = [spannedCells allKeysForObject:spanningCell];
	[spannedCells removeObjectsForKeys:keys];	
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) clearUnneededCells:(CGRect) workingCells
{
	CGRect contentRect = self.bounds;
	contentRect.origin = self.contentOffset;

	for (UIXGridViewCell* cell in [cells allValues])
	{
		CGRect cellRect = cell.frame;
		CGRect intersect = CGRectIntersection(cellRect, contentRect);
		
		if (CGRectIsNull(intersect) || hasNewData)
		{
			if ([cell isKindOfClass:[UIXGridViewSpanningCell class]])
			{
				[self clearSpanned:(UIXGridViewSpanningCell*) cell];
			}
			
			[cell removeFromSuperview];
			[self enqueueCell:cell];
			
			NSIndexPath* ip = [[cells allKeysForObject:cell] lastObject];
			[cells removeObjectForKey:ip];
		}
	}
}


//////////////////////////////////////
//
//////////////////////////////////////
- (void) placeCell:(UIXGridViewCell*)cell atIndex:(NSIndexPath*) ip size:(CGSize) sz
{
	CGRect frame;
	
	frame.origin = [self calcCellPosition: ip];
	frame.size = sz;
	[cells setObject:cell forKey:ip];
	cell.frame = frame;
	
	if ([cell isKindOfClass:[UIXGridViewSpanningCell class]])
	{
		UIXGridViewSpanningCell* spancell = (UIXGridViewSpanningCell*) cell;
		
		for (int wndx=0; wndx < spancell.widthInCells; ++wndx)
		{
			for (int hndx=0; hndx < spancell.heightInCells; ++hndx)
			{
				NSIndexPath* spannedIP = [NSIndexPath indexPathForColumn:[ip column]+wndx row:[ip row]+hndx];
				if (![spannedIP isEqual:ip])
				{
					[spannedCells setObject:spancell forKey:spannedIP];
				}
			}
		}
	}
	
	[self addSubview:cell];
    
    if ([selectionIndexPaths containsObject:ip])
    {
        [cell setSelected:YES animated:NO];
    }
}

//////////////////////////////////////
//
//////////////////////////////////////
- (CGSize) spanningCellSize:(UIXGridViewSpanningCell*) spanningCell
{
	CGSize size = CGSizeMake((cellWidth * spanningCell.widthInCells) + (verticalGridLineWidth * (spanningCell.widthInCells-1)),
							 (cellHeight * spanningCell.heightInCells) + (horizontalGridLineWidth * (spanningCell.heightInCells-1)));
	return size;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (CGRect) calcWorkingCells
{
	CGRect contentRect = self.bounds;
	contentRect.origin = self.contentOffset;
	CGFloat xmax = CGFLOAT_MIN;
	CGFloat xmin = CGFLOAT_MAX;
	CGFloat ymax = CGFLOAT_MIN;
	CGFloat ymin = CGFLOAT_MAX;
	
	for (CGFloat xndx=0; xndx < columns; ++xndx)
	{
		for (CGFloat yndx=0; yndx < rows; ++yndx)
		{
			CGRect cellRect = CGRectMake(0, 0, cellWidth, cellHeight);
			cellRect.origin = [self calcCellPosition:[NSIndexPath indexPathForColumn:xndx row:yndx]];
			CGRect intersect = CGRectIntersection(cellRect, contentRect);
			if (!CGRectIsNull(intersect))
			{
				xmax = MAX(xndx,xmax);
				xmin = MIN(xndx,xmin);
				ymax = MAX(yndx,ymax);
				ymin = MIN(yndx,ymin);
			}
		}
	}
	
	CGRect r =  CGRectMake(xmin, ymin, MIN(columns,(xmax-xmin)+1), MIN(rows,(ymax-ymin)+1));
	return r;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) updateVisibleCells:(CGRect) workingCells
{
    CGRect frame;
	CGSize size;
	UIXGridViewCell* cell;
    
	//We have changed what is displaying (either through movement or data), so lets get to it
	frame = self.frame;	
	CGFloat baseY = 0;
    
	//adjust size based on header and footer
	if (headerView)
	{
		baseY = headerView.bounds.size.height;
		frame = headerView.frame;
		frame.size.width = contentSize.width;
		headerView.frame = frame;
	}
    
	//clear out the old
	[self clearUnneededCells:workingCells];
	
	//add the new
	for (NSInteger r = workingCells.origin.y; r < workingCells.origin.y + workingCells.size.height; r++)
	{
		for (NSInteger c = workingCells.origin.x; c < workingCells.origin.x + workingCells.size.width; c++)
		{
			NSIndexPath* ip = [NSIndexPath indexPathForColumn:c row:r];
			
			UIXGridViewCell* spanningCell = [spannedCells objectForKey:ip];
			if (spanningCell != nil)
			{
				continue; //this cell is covered by a spanning cell, screw it
			}
			
			UIView* v = [cells objectForKey:ip];  
			if (v == nil) //if cell not currently displayed
			{
				cell = [self.dataSource UIXGridView:self cellForIndexPath:ip];   
				if (cell != nil)
				{
					if ([cell isKindOfClass:[UIXGridViewSpannedCell class]])
					{
						NSIndexPath* spanningIndexPath = nil;
						
						UIXGridViewSpanningCell* spanningCell = [self.dataSource UIXGridView:self
																		 spanningCellAtIndex:&spanningIndexPath
                                                                            forSpannedCellAt:ip];
                        
						[self placeCell:spanningCell 
                                atIndex:spanningIndexPath 
                                   size:[self spanningCellSize:spanningCell]];
						
						//skip the rest
						continue;
					}
					else if ([cell isKindOfClass:[UIXGridViewSpanningCell class]])
					{
						UIXGridViewSpanningCell* spancell = (UIXGridViewSpanningCell*) cell;
						
						size = [self spanningCellSize:spancell];
					}
					else
					{
						size = CGSizeMake(cellWidth, cellHeight);
					}
                    
					[self placeCell:cell atIndex:ip size:size];
                    [cell setNeedsLayout];
					[self setNeedsDisplay];
				}	
			}
		}//end for
	}//end for
	
	
	if (footerView)
	{
		frame = footerView.frame;
		frame.size.width = contentSize.width;
        frame.origin.y = contentSize.height - frame.size.height;
		footerView.frame = frame;
	}
    
	self.contentSize = contentSize;	
    
	hasNewData = NO;    
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)layoutSubviews
{
    if (calculateGeometryOnLayout)
    {
        [self calcGeometry];
    }
	
	CGRect workingCells;
    
	workingCells = [self calcWorkingCells];
	
    if (!CGRectEqualToRect(workingCells, currentlyDisplayedCells))
    {
        [self updateVisibleCells:workingCells];
        currentlyDisplayedCells = workingCells;
    }
    
	[super layoutSubviews];
}


/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (NSIndexPath*) indexPathForCell:(UIXGridViewCell*) cell
{
	for (NSIndexPath* p in [cells allKeys])
	{
		if ([cells objectForKey:p] == cell)
		{
			return p;
		}
	}
	
	return nil;
}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (void) informWillSelectCell:(UIXGridViewCell*) cell
{
	NSIndexPath* p = [self indexPathForCell:cell];
	if (p != nil)
	{
		//		[self clearSelection];
		if (self.gridDelegate != nil)
		{
			if ([self.gridDelegate respondsToSelector:@selector(UIXGridView:willSelectCellAtIndexPath:)])
			{
				[self.gridDelegate UIXGridView: self  willSelectCellAtIndexPath:p];
			}
		}
	}
}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (void) informDidSelectCell:(UIXGridViewCell*) cell
{
	NSIndexPath* p = [self indexPathForCell:cell];
	
	if (p != nil)
	{
        if (selectionStyle != UIXGridViewSelectionStyleMultiple)
        {
            [self clearSelection];
            //            [selectedCellIndexPath release];
		}
        
        [selectionIndexPaths addObject:p];
        //		selectedCellIndexPath = [p retain];
        
		if (self.gridDelegate != nil)
		{
			if ([self.gridDelegate respondsToSelector:@selector(UIXGridView:didSelectCellAtIndexPath:)])
			{
				[self.gridDelegate UIXGridView: self  didSelectCellAtIndexPath:p];
			}
		}
	}
}

/////////////////////////////////////////////////
// !!!: this only gets applied in multi, should be any
/////////////////////////////////////////////////
- (void) informDidUnselectCell:(UIXGridViewCell*) cell
{
	NSIndexPath* p = [self indexPathForCell:cell];
	
	if (p != nil)
	{
        [selectionIndexPaths removeObject:p];
        
		if (self.gridDelegate != nil)
		{
			if ([self.gridDelegate respondsToSelector:@selector(UIXGridView:didDeselectCellAtIndexPath:)])
			{
				[self.gridDelegate UIXGridView: self  didDeselectCellAtIndexPath:p];
			}
		}
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) callDidDeselectDelegateForIndexPath:(NSIndexPath*) path
{
	[selectionIndexPaths removeObject:path];

	if (self.gridDelegate != nil)
	{
		if ([self.gridDelegate respondsToSelector:@selector(UIXGridView:didDeselectCellAtIndexPath:)])
		{
			[self.gridDelegate UIXGridView: self didDeselectCellAtIndexPath: path];
		}
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) callWillDeselectDelegateForIndexPath:(NSIndexPath*) indexPath
{
	if (self.gridDelegate != nil)
	{
		if ([self.gridDelegate respondsToSelector:@selector(UIXGridView:willDeselectCellAtIndexPath:)])
		{
			[self.gridDelegate UIXGridView: self willDeselectCellAtIndexPath: indexPath];
		}
	}
}


//////////////////////////////////////
//
//////////////////////////////////////
- (void) deselectCellAtIndexPath:(NSIndexPath*) indexPath animated:(BOOL) animate
{
	UIXGridViewCell* cell = [self cellAtIndexPath:indexPath];
	
	if (cell != nil)
	{
		[self callWillDeselectDelegateForIndexPath:indexPath];
		[cell setSelected:NO animated: animate];
		[self callDidDeselectDelegateForIndexPath:indexPath];
		[cell setNeedsDisplay];
	}
	
	// FIXME: this will fail if try to deselect cell not selected
	
	[selectionIndexPaths removeObject:indexPath];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) deselectCell:(UIXGridViewCell*) cell 
{
	NSArray* arr = [cells allKeysForObject:cell];
	
	NSIndexPath* indexPath = [arr objectAtIndex:0];

	[self deselectCellAtIndexPath:indexPath animated:NO];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) selectCellAtIndexPath:(NSIndexPath*) indexPath animated:(BOOL) animate
{
	UIXGridViewCell* cell = [self cellAtIndexPath:indexPath];
	
	if (cell != nil)
	{
		[self informWillSelectCell:cell];
		[cell setSelected:YES animated: animate];
		[self informDidSelectCell:cell];
		[cell setNeedsDisplay];
	}
	
	//FIXME - isnt this redundant with the selectCell call?
	[selectionIndexPaths addObject:indexPath];
	
	[self setNeedsDisplay];
}


/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//}


//////////////////////////////////////
//
//////////////////////////////////////
- (void)drawGridLines
{
	CGRect frame;
	CGPoint start, end;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// FIXME: Never set the pen size at all
	
	if (borderGridLineWidth || horizontalGridLineWidth || verticalGridLineWidth)
	{
		[gridLineColor set];  // !!!this is nil by default
		CGContextBeginPath(context);  
	
		//border
		if (borderGridLineWidth)
		{
			CGContextSetLineWidth(context, borderGridLineWidth);
			CGFloat insetAdjust = borderGridLineWidth/2; 
			CGContextSetLineWidth(context, borderGridLineWidth);
			frame.origin.x = insetAdjust;
			frame.origin.y = insetAdjust;
			frame.size.width = contentSize.width-borderGridLineWidth;
			frame.size.height = contentSize.height;
            
            //adjust for header & footer
            if (headerView != nil)
            {
                CGRect headerFrame = headerView.bounds;
                frame.origin.y += headerFrame.size.height;
                frame.size.height -= headerFrame.size.height;
            }

            if (footerView != nil)
            {
                CGRect footerFrame = footerView.bounds;
                frame.size.height -= footerFrame.size.height;
            }
            
            frame.size.height -= borderGridLineWidth;
			CGContextAddRect (context,frame);
		}
		
		if (horizontalGridLineWidth)
		{
			CGContextSetLineWidth(context, horizontalGridLineWidth);
			for (CGFloat ndx = 1.0; ndx < (rows); ++ndx)
			{
				start.x = borderGridLineWidth;
				end.x = contentSize.width - borderGridLineWidth;
				start.y = (borderGridLineWidth + (cellHeight * ndx) + (horizontalGridLineWidth * ndx)) - (horizontalGridLineWidth/2);
                if (headerView != nil)
                {
                    start.y += headerView.bounds.size.height;
                }
                
                end.y = start.y;
                
				CGContextMoveToPoint(context, start.x, start.y);
				CGContextAddLineToPoint(context, end.x, end.y);
			}	
		}
		
		if (verticalGridLineWidth)
		{
			CGContextSetLineWidth(context, verticalGridLineWidth);
			for (CGFloat ndx = 1.0; ndx < (columns); ++ndx)
			{
                start.y = borderGridLineWidth;
                if (headerView != nil)
                {
                    start.y += headerView.bounds.size.height;
                }
                
				end.y = contentSize.height - borderGridLineWidth;
                if (footerView != nil)
                {
                    end.y -= footerView.bounds.size.height;
                }
                
				start.x = end.x = (borderGridLineWidth + (cellWidth * ndx) + (verticalGridLineWidth * ndx)) - (verticalGridLineWidth/2);
				CGContextMoveToPoint(context, start.x, start.y);
				CGContextAddLineToPoint(context, end.x, end.y);
			}	
		}
		
		CGContextClosePath(context);  
		CGContextDrawPath(context, kCGPathStroke);	
	}
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

	[super drawRect:rect];
}

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

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (void) setHeaderView: (UIView*) view
{
	CGFloat change;
	CGRect frame;
	CGSize size;
	
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
	CGSize size;
	
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
			cell = [[arr objectAtIndex:0] retain];
			[arr removeObjectAtIndex:0];
//			NSLog(@"cell reused: %08X",cell);

		}
		
	}
	
	return [cell autorelease];
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

#pragma mark new arch

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (BOOL) shouldRespondToTouch:(UIXGridViewCell*) cell
{
	BOOL result = YES;
	
	NSIndexPath* p = [self indexPathForCell:cell];
	if (p != nil)
	{
		if (self.gridDelegate != nil)
		{
//			if ([self.gridDelegate respondsToSelector:@selector(UIXGridView:shouldSelectCellAtIndexPath:)])
//			{
//				result = [self.gridDelegate UIXGridView: self  shouldSelectCellAtIndexPath:p];
//			}
		}
	}
	
	return result;
}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (void) clearSelection
{
//	if (selectedCellIndexPath != nil)
//	{
//		[self deselectCellAtIndexPath:selectedCellIndexPath animated:NO];
//		[selectedCellIndexPath release];
//		selectedCellIndexPath = nil;
//	}
    
    for (NSIndexPath* ip in  [selectionIndexPaths allObjects])
    {
		[self deselectCellAtIndexPath:ip animated:NO];
    }
    
    [selectionIndexPaths removeAllObjects];
}


/////////////////////////////////////////////////
//
/////////////////////////////////////////////////
- (UIColor*) selectionBackgroundColorForCell:(UIXGridViewCell*) cell
{
	//UIColor* result = self.selectionColor;
	UIColor* result = [UIColor blueColor];
	
//	NSIndexPath* p = [self indexPathForCell:cell];
//	
//	if ([gridDelegate respondsToSelector:@selector(UIXGridView:selectionBackgroundColorForCellAtIndexPath:)])
//	{
//		result = [gridDelegate UIXGridView: self selectionBackgroundColorForCellAtIndexPath:p];
//	}
//	else
//    {
//        result = 
//    }
	return result;
}

@end

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
@implementation NSIndexPath (UIXGridView)

@dynamic column;
@dynamic row;

+ (NSIndexPath *)indexPathForColumn:(NSUInteger)column row:(NSUInteger) row 
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
