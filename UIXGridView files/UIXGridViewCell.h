//
//  UIXGridViewCell.h
//  GridViewExamples
//
//  Created by gumbright on 4/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum 
{
	UIXGridViewCellStyleDefault
} UIXGridViewCellStyle;


@interface UIXGridViewCell : UIView 
{
	UIView* contentView;
	UIView* backgroundView;
	UIView* selectedBackgroundView;
	UIView* selectionOverlayView;
	
	//selection
	BOOL selected;
	BOOL highlighted;
    BOOL overlayOnlySelection;
	
	UIXGridViewCellStyle* _style;
	
	NSString* _reuseIdentifier;
	
@private
	//default views
	UILabel* _textLabel;
	UIImageView* _imageView;
	UIView* _displayedSelectedBackgroundView;
	UIView* _displayedSelectionOverlayView;
	
	NSMutableDictionary* savedViewState;
	
	BOOL unhighlighting;
}

@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, assign, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, assign) BOOL overlayOnlySelection;

@property (readonly) UIXGridViewCellStyle* style;

@property (readonly) UILabel* textLabel;
@property (readonly) UIImageView* imageView;

@property (readonly) UIView* contentView;
@property (nonatomic, retain) UIView* backgroundView;
@property (nonatomic, retain) UIView* selectedBackgroundView;
@property (nonatomic, retain) UIView* selectionOverlayView;

@property (readonly) NSString* reuseIdentifier;

- (id)initWithStyle:(UIXGridViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

//differs from UITableView in that it calls prepareForReuse when it places a reusable cell back into the pool
- (void)prepareForReuse;

- (void) setSelected:(BOOL) f animated:(BOOL) animate;
- (void) setHighlighted:(BOOL) f animated:(BOOL) animated;
@end

@interface UIXGridViewSelectionOverlayView : UIView 
{
    UIView* icon;
}

- (id) init;
@end
