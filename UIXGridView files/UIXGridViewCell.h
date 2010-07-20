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
	UIView* overlayView;
	
	//selection
	BOOL selected;
	BOOL highlighted;
	
	UIXGridViewCellStyle* style;
	
	NSString* reuseIdentifier;
	
@private
	//default views
	UILabel* _textLabel;
	UIImageView* _imageView;
	UIView* _displayedSelectedBackgroundView;
	
	NSMutableDictionary* savedViewState;
	
	BOOL unhighlighting;
}

@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

@property (readonly) UIXGridViewCellStyle* style;

@property (readonly) UILabel* textLabel;
@property (readonly) UIImageView* imageView;

@property (readonly) UIView* contentView;
@property (nonatomic, retain) UIView* backgroundView;
@property (nonatomic, retain) UIView* selectedBackgroundView;
@property (nonatomic, retain) UIView* overlayView;

@property (readonly) NSString* reuseIdentifier;

- (id)initWithStyle:(UIXGridViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

//differs from UITableView in that it calls prepareForReuse when it places a reusable cell back into the pool
- (void)prepareForReuse;

- (void) setSelected:(BOOL) f animated:(BOOL) animate;
@end
