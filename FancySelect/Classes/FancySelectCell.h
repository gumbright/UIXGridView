//
//  FancySelectCell.h
//  FancySelect
//
//  Created by gumbright on 8/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIXGridViewCell.h"

@interface BorderView : UIView
{
	BOOL selected;
}

@property (assign) BOOL selected;

- (void) drawRect:(CGRect) rect;

@end

@interface FancySelectCell : UIXGridViewCell 
{
	BorderView* borderView;
	UIImageView* iconView;
	UILabel* cellLabel;
	
	UIImage* onImage;
	UIImage* offImage;
}

@property (readonly) BorderView* borderView;
@property (readonly) UIImageView* iconView;
@property (readonly) UILabel* cellLabel;

@property (nonatomic, retain) UIImage* onImage;
@property (nonatomic, retain) UIImage* offImage;

- (id) initWithReuseIdentifier:(NSString*) reuseId;
- (void) setSelected:(BOOL) f;
@end
