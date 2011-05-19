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
#import "UIXGridViewSpanningCell.h"

//#import "UIXGridViewCell.h"

@protocol UIXGridViewDataSource, UIXGridViewDelegate;


typedef enum
{
    UIXGridViewStyleConstrained=0,
    UIXGridViewStyleHorzConstrained,
    UIXGridViewStyleVertConstrained,
    UIXGridViewStyleUnconstrained
} UIXGridViewStyle;

typedef enum
{
    UIXGridViewSelectionStyleSingle=0,
    UIXGridViewSelectionStyleMultiple,
    UIXGridViewSelectionStyleMomentary
} UIXGridViewSelectionStyle;

typedef enum
{
    UIXGridViewOverlayStyleCheckmark=0,
    UIXGridViewOverlayStyleImage
} UIXGridViewOverlayStyle;

@interface UIXGridView : UIScrollView <UIScrollViewDelegate>
{
	BOOL initialSetupDone;
	
	//operational
	BOOL startSelect;

	//currently displayed cells
	NSMutableDictionary* cells;
	CGRect currentlyDisplayedCells;	//rect describing the cell paths being shown

	NSInteger numHorzCellsVisible;
	NSInteger numVertCellsVisible;
	
	CGSize contentSize;
	
	BOOL hasNewData;
	
	//cell queue
	NSMutableArray* cellQueue;
	NSMutableDictionary* reusableCells;
	
	NSMutableSet* selectionIndexPaths;  //selected cell paths
	
	NSMutableDictionary* spannedCells; //indexPaths, data is parent cell
    
    BOOL calculateGeometryOnLayout;
    
}

@property (readonly) NSInteger columns;
@property (readonly) NSInteger rows;
@property (readonly) BOOL constrainHorzToScreenSize;
@property (readonly) BOOL constrainVertToScreenSize;
@property (assign) BOOL customSelect;

@property (readonly) NSInteger style;

@property (assign) id dataSource;
@property (assign) id gridDelegate;
@property UIEdgeInsets cellInsets;

@property (nonatomic, retain) UIView* headerView;
@property (nonatomic, retain) UIView* footerView;

@property () CGFloat horizontalGridLineWidth;
@property () CGFloat verticalGridLineWidth;
@property () CGFloat borderGridLineWidth;
@property (nonatomic,retain) UIColor* gridLineColor;

@property (readonly) CGFloat cellWidth;
@property (readonly) CGFloat cellHeight;

@property (readonly) UIXGridViewStyle gridStyle;
@property (assign) UIXGridViewSelectionStyle selectionStyle;
@property (assign) UIXGridViewOverlayStyle overlayStyle;

- (id)initWithFrame:(CGRect) frame 
           andStyle:(UIXGridViewStyle) style;
- (id)initWithFrame:(CGRect) frame 
           andStyle:(UIXGridViewStyle) style 
      selectionType:(UIXGridViewSelectionStyle) selectionType;

- (UIXGridViewCell*) cellAtIndexPath:(NSIndexPath*) path;
- (NSArray*) visibleCells;

- (NSArray*) selection;

//- (void) selectCell:(UIXGridViewCell*) cell;  //the questionis whether this should be external, and I think not, should be index path based
- (void) selectCellAtIndexPath:(NSIndexPath*) indexPath animated:(BOOL) animated;
- (void) deselectCell:(UIXGridViewCell*) cell;
//- (void) deselectCellAtIndexPath:(NSIndexPath*) indexPath;

- (NSArray*) selectedCellsIndexPaths;
- (NSArray*) selectedCells;
- (void) clearSelection;

- (BOOL) cellIsSelected:(UIXGridViewCell *)cell;
- (BOOL) indexPathIsSelected:(NSIndexPath*) path;

- (void) reloadData;

- (UIXGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

//////////////////////////////////
// new cell arch
//////////////////////////////////
- (void) deselectCellAtIndexPath:(NSIndexPath*) indexPath animated:(BOOL) animate;

- (BOOL) shouldRespondToTouch:(UIXGridViewCell*) cell;
- (void) informWillSelectCell:(UIXGridViewCell*) cell;
- (void) informDidSelectCell:(UIXGridViewCell*) cell;
- (void) informDidUnselectCell:(UIXGridViewCell*) cell;

- (UIColor*) selectionBackgroundColorForCell:(UIXGridViewCell*) cell;

@end

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

- (UIXGridViewSpanningCell*) UIXGridView:(UIXGridView*) grid spanningCellAtIndex:(NSIndexPath**) spanningCellIndex forSpannedCellAt:(NSIndexPath*) indexPath;
@end

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
@protocol UIXGridViewDelegate<NSObject>

@optional
- (NSIndexPath*) UIXGridView: (UIXGridView*) gridView  willSelectCellAtIndexPath:(NSIndexPath*) indexPath;
- (void) UIXGridView: (UIXGridView*) gridView  didSelectCellAtIndexPath:(NSIndexPath*) indexPath;

- (NSIndexPath*) UIXGridView: (UIXGridView*) gridView  willDeselectCellAtIndexPath:(NSIndexPath*) indexPath;
- (void) UIXGridView: (UIXGridView*) gridView  didSDeselectCellAtIndexPath:(NSIndexPath*) indexPath;

//- (UIColor*) UIXGridView: (UIXGridView*) gridView selectionBackgroundColorForCellAtIndexPath:(NSIndexPath*) indexPath;

//- (UIXGridViewCellSelectionStyle) UIXGridView: (UIXGridView*) gridView  selectionStyleForCellAtIndexPath:(NSIndexPath*) indexPath;

//- (void)UIXGridView:(UITableView *)tableView willDisplayCell:(UIXGridViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
@end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
// This category provides convenience methods to make it easier to use an NSIndexPath to represent a section and row
@interface NSIndexPath (UIXGridView)

+ (NSIndexPath *)indexPathForColumn:(NSUInteger)column row:(NSUInteger)row;

@property(nonatomic,readonly) NSUInteger column;
@property(nonatomic,readonly) NSUInteger row;

@end

