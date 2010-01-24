//
//  UIXGridView.h
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

#import <Foundation/Foundation.h>
#import "UIXGridViewCell.h"

@protocol UIXGridViewDataSource, UIXGridViewDelegate;

@class UIXGridViewCell;

#define UIXGridViewStyle_Constrained		0
#define UIXGridViewStyle_HorzConstrained	1
#define UIXGridViewStyle_VertConstrained	2
#define UIXGridViewStyle_Unconstrained		3
	
#define UIXGridViewSelectionType_Momentary	0
#define UIXGridViewSelectionType_Single		1
#define UIXGridViewSelectionType_Multiple	2

//conform to NSCoder?
@interface UIXGridView : UIScrollView <UIScrollViewDelegate>
{
	//configuration
	UIColor* selectionColor;
	UIEdgeInsets cellInsets;
	id <UIXGridViewDataSource> dataSource;
	NSInteger style;
	NSInteger selectionType;
	BOOL initialSetupDone;
	
	//attribute
	BOOL constrainHorzToScreenSize;
	BOOL constrainVertToScreenSize;
	BOOL customSelect;
	
	//operational
	BOOL startSelect;

	NSMutableDictionary* cells;

//	NSInteger columnWidth;
//	NSInteger rowHeight;
	NSInteger numHorzCellsVisible;
	NSInteger numVertCellsVisible;
	
	//geometry
	NSInteger columns;
	NSInteger rows;
	CGFloat cellWidth;
	CGFloat cellHeight;
	CGSize contentSize;
	
	CGRect currentlyDisplayedCells;
	
	UIView* headerView;
	UIView* footerView;
	
	BOOL hasNewData;
	
	//cell queue
	NSMutableArray* cellQueue;
	NSMutableDictionary* reusableCells;
	
	NSMutableSet* selectionIndexPaths;
	
	//gridlines
	CGFloat horizontalGridLineWidth;
	CGFloat verticalGridLineWidth;
	CGFloat borderGridLineWidth;
	UIColor* gridLineColor;

}

@property (readonly) NSInteger columns;
@property (readonly) NSInteger rows;
@property (readonly) BOOL constrainHorzToScreenSize;
@property (readonly) BOOL constrainVertToScreenSize;
@property (assign) BOOL customSelect;
//@property (readonly) NSInteger columnWidth;
//@property (readonly) NSInteger rowHeight;
@property (readonly) NSInteger style;
@property (readonly) NSInteger selectionType;

@property (nonatomic, retain) id dataSource;
@property UIEdgeInsets cellInsets;
@property (nonatomic, retain) UIColor* selectionColor;

@property (nonatomic, retain) UIView* headerView;
@property (nonatomic, retain) UIView* footerView;

@property () CGFloat horizontalGridLineWidth;
@property () CGFloat verticalGridLineWidth;
@property () CGFloat borderGridLineWidth;
@property (nonatomic,retain) UIColor* gridLineColor;

@property (readonly) CGFloat cellWidth;
@property (readonly) CGFloat cellHeight;

//@property (readonly) UIXGridViewCell*  selectedCell;


- (id)initWithFrame:(CGRect) frame andStyle:(NSInteger) style selectionType:(NSInteger) selectionType;

- (UIXGridViewCell*) cellAtIndexPath:(NSIndexPath*) path;
- (NSArray*) visibleCells;

- (NSArray*) selection;

- (void) selectCell:(UIXGridViewCell*) cell;  //the questionis whether this should be external, and I think not, should be index path based
- (void) selectCellAtIndexPath:(NSIndexPath*) indexPath;
- (void) deselectCell:(UIXGridViewCell*) cell;
- (void) deselectCellAtIndexPath:(NSIndexPath*) indexPath;

- (NSArray*) selectedCellsIndexPaths;
- (NSArray*) selectedCells;
- (void) clearSelection;

- (BOOL) cellIsSelected:(UIXGridViewCell *)cell;
- (BOOL) indexPathIsSelected:(NSIndexPath*) path;

- (void) reloadData;

//- (UIXGridViewCell*)dequeueReusableCell;
- (UIXGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

//touch notifications from cells (best treated private)
- (void) cellTouched:(UIXGridViewCell*) cell;
- (void) cellReleased:(UIXGridViewCell*) cell;
- (void) cellTouchMoved:(UIXGridViewCell*) cell withEvent:(UIEvent*) event;



@end

typedef enum {
	UIXGridViewCellSelectionStyleNone,
	UIXGridViewCellSelectionStyleRect,
	UIXGridViewCellSelectionStyleRoundRect  //going to need the radius eventually
} UIXGridViewCellSelectionStyle;

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
@protocol UIXGridViewDataSource<NSObject>

@required

- (UIXGridViewCell*) UIXGridView:(UIXGridView*) grid cellForIndexPath:(NSIndexPath*) indexPath;
- (NSInteger) numberOfColumnsForGrid:(UIXGridView*) grid;
- (NSInteger) numberOfRowsForGrid: (UIXGridView*) grid;

@optional
- (NSInteger) cellWidthForGrid:(UIXGridView*) grid;
- (NSInteger) cellHeightForGrid:(UIXGridView*) grid;

@end

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
@protocol UIXGridViewDelegate<NSObject>

@optional
- (BOOL) UIXGridView: (UIXGridView*) gridView  shouldSelectCellForIndexPath:(NSIndexPath*) indexPath;
- (void) UIXGridView: (UIXGridView*) gridView  willSelectCellForIndexPath:(NSIndexPath*) indexPath;
- (void) UIXGridView: (UIXGridView*) gridView  didSelectCellForIndexPath:(NSIndexPath*) indexPath;

- (void) UIXGridView: (UIXGridView*) gridView  willDeselectCellForIndexPath:(NSIndexPath*) indexPath;
- (void) UIXGridView: (UIXGridView*) gridView  didSDeselectCellForIndexPath:(NSIndexPath*) indexPath;

- (UIXGridViewCellSelectionStyle) UIXGridView: (UIXGridView*) gridView  selectionStyleForCellAtIndexPath:(NSIndexPath*) indexPath;
@end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
// This category provides convenience methods to make it easier to use an NSIndexPath to represent a section and row
@interface NSIndexPath (UIXGridView)

+ (NSIndexPath *)indexPathForRow:(NSUInteger)row inColumn:(NSUInteger)column;

@property(nonatomic,readonly) NSUInteger column;
@property(nonatomic,readonly) NSUInteger row;

@end

