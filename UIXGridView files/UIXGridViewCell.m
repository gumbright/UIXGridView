//
//  UIXGridViewCell.m
//  GridViewExamples
//
//  Created by gumbright on 4/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import "UIXGridView.h"
#import "UIXGridViewCell.h"
#import "UIXGridView.h"

@implementation UIXGridViewCell

@dynamic selected;
@synthesize highlighted;

@synthesize style;

@dynamic textLabel;
@dynamic imageView;
@dynamic overlayView;

@synthesize contentView;
@synthesize backgroundView;
@synthesize selectedBackgroundView;

@synthesize reuseIdentifier;

//////////////////////////////////////
//
//////////////////////////////////////
- (id)initWithStyle:(UIXGridViewCellStyle)style reuseIdentifier:(NSString *)reuseId
{
	if (self = [super initWithFrame:CGRectZero])
	{
		UIView* v;
		
		self.clipsToBounds = YES;
		self.backgroundColor = [UIColor clearColor];
		
		v = [[UIView alloc] initWithFrame:CGRectZero];
		[self addSubview:v];
//		v.tag = 111;
		[v release];
		backgroundView = v;
		backgroundView.backgroundColor = [UIColor whiteColor];
		selectedBackgroundView = nil;
		
		v = [[UIView alloc] initWithFrame:CGRectZero];
//		v.tag = 222;
		[self addSubview:v];
		self.backgroundColor = [UIColor clearColor];
		[v release];
		contentView = v;
		
		reuseIdentifier = [[NSString stringWithString: reuseId] retain];
	}
	
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//////////////////////////////////////
//
//////////////////////////////////////
- (void)dealloc 
{
    [super dealloc];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) highlightSubviews:(UIView*) view savingStateIn:(NSMutableDictionary*) savedStateDict
{
	BOOL hasHighlight;
	
	for (NSUInteger ndx = 0; ndx < [view.subviews count]; ndx++)
	{
		UIView* subview = [view.subviews objectAtIndex:ndx];
		
		//highlight
		NSMutableDictionary* stateDict = [NSMutableDictionary dictionary];

		hasHighlight = NO;
		
		if ([subview respondsToSelector:@selector(isHighlighted)] && [subview respondsToSelector:@selector(setHighlighted:)])
		{
			[stateDict setObject:[NSNumber numberWithBool:(BOOL)[subview isHighlighted]] forKey:@"h"];
			 hasHighlight = YES;
		}
			 
		[stateDict setObject:[NSNumber numberWithBool:subview.opaque] forKey:@"o"];
		UIColor* bc = subview.backgroundColor;
		if (bc != nil)
		{
			[stateDict setObject:subview.backgroundColor forKey:@"bc"];
		}	
		 
		[savedStateDict setObject:stateDict forKey:[NSNumber numberWithUnsignedInt:subview.hash]];
		 
		if (hasHighlight)
		{
			[subview setHighlighted:YES];
		}
		 
		 subview.opaque = NO;
		 subview.backgroundColor = [UIColor clearColor];
		
		[self highlightSubviews:subview savingStateIn:savedStateDict];
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) highlightCell
{
	//insert background
	UIColor* bgColor;
	
	if (selectedBackgroundView == nil)
	{
		_displayedSelectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		_displayedSelectedBackgroundView.tag = 333;
		UIXGridView* grid = (UIXGridView*) self.superview;
		bgColor = [grid selectionBackgroundColorForCell:self];
		_displayedSelectedBackgroundView.backgroundColor = bgColor;
	}
	else 
	{
		_displayedSelectedBackgroundView = selectedBackgroundView;
	}

//	[self insertSubview:_displayedSelectedBackgroundView  atIndex:0];
	[self insertSubview:_displayedSelectedBackgroundView aboveSubview:backgroundView];
	
	
	CGRect frame;
	frame.size = self.frame.size;
	frame.origin = CGPointMake(0, 0);
	_displayedSelectedBackgroundView.frame = frame;
	
	savedViewState = [[NSMutableDictionary dictionary] retain];
	[self highlightSubviews:contentView savingStateIn: savedViewState];
	
	self.highlighted = YES;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) unhighlightSubviews:(UIView*) view
{
	for (NSUInteger ndx = 0; ndx < [view.subviews count]; ndx++)
	{
		UIView* subview = [view.subviews objectAtIndex:ndx];
		
		NSDictionary* stateDict = [savedViewState objectForKey:[NSNumber numberWithUnsignedInt:subview.hash]];
		
		if ([subview respondsToSelector:@selector(isHighlighted)] && [subview respondsToSelector:@selector(setHighlighted:)])
		{
			NSNumber* highlightState = [stateDict objectForKey:@"h"];
			[subview setHighlighted:[highlightState boolValue]];
		}	
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) restoreSubviews:(UIView*) view
{
	for (NSUInteger ndx = 0; ndx < [view.subviews count]; ndx++)
	{
		UIView* subview = [view.subviews objectAtIndex:ndx];
		
		NSDictionary* stateDict = [savedViewState objectForKey:[NSNumber numberWithUnsignedInt:subview.hash]];
		
		NSNumber* highlightState = [stateDict objectForKey:@"h"];
		if (highlightState != nil)
		{
			[subview setHighlighted:[highlightState boolValue]];
		}
		
		NSNumber* opaqueState = [stateDict objectForKey:@"o"];
		subview.opaque = [opaqueState boolValue];
		
		UIColor* bc = [stateDict objectForKey:@"bc"];
		subview.backgroundColor = bc;
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"backgroundFade1"])
	{
		[self unhighlightSubviews:contentView];
		[UIView beginAnimations:@"backgroundFade2" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.1];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		 _displayedSelectedBackgroundView.alpha = 0.0;
		 [UIView commitAnimations];
	}
	else 
	{
		[self restoreSubviews:contentView];
		[savedViewState release];
		savedViewState = nil;
//		NSLog(@"savedViewState released");
		self.highlighted = NO;
		
		[_displayedSelectedBackgroundView removeFromSuperview];
		_displayedSelectedBackgroundView = nil;
		if (selectedBackgroundView != nil)
		{
			selectedBackgroundView.alpha = 1.0;
		}
//		unhighlighting = NO;
	}

		
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) unhighlightCell:(BOOL) animated
{
	//table fades and unhighlights at halfway
	//for now just undo what we did in reverse
	if (animated)
	{
		[UIView beginAnimations:@"backgroundFade1" context:nil];
		[UIView setAnimationDuration:0.1];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		_displayedSelectedBackgroundView.alpha = 0.5;
		[UIView commitAnimations];
	}
	else 
	{
		[self unhighlightSubviews:contentView];
		[self restoreSubviews:contentView];
		[savedViewState release];
//		NSLog(@"savedViewState released");
		savedViewState = nil;
		self.highlighted = NO;
		
//		UIView* v =  _displayedSelectedBackgroundView.superview;
		[_displayedSelectedBackgroundView removeFromSuperview];
//		v =  _displayedSelectedBackgroundView.superview;
		_displayedSelectedBackgroundView = nil;
		if (selectedBackgroundView != nil)
		{
			selectedBackgroundView.alpha = 1.0;
		}
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"UIXGridViewCell - touchesEnded %@",self);

	if (self.isHighlighted /*&& !unhighlighting*/)
	{
		UIXGridView* grid = (UIXGridView*) self.superview;
		//do will select
		[grid informWillSelectCell:self];
		[self unhighlightCell:NO];
//		NSLog(@"Yay selected!");
		self.selected = YES;
		
		[grid informDidSelectCell:self];
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"UIXGridViewCell - touchesBegan %@",touches);
	
	if ([touches count] == 1)
	{		
		UIXGridView* grid = (UIXGridView*) self.superview;
		if ([grid shouldRespondToTouch:self])
		{
			[self highlightCell];
		}	
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"UIXGridViewCell - touchesMoved %@",self);
	if (self.isHighlighted /*&& !unhighlighting*/)
	{
//		unhighlighting = YES;
		[self unhighlightCell:NO];
	}	
//	else
//	{
//		int x = 999;
//	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)prepareForReuse
{
	[self setSelected:NO animated:NO];
	highlighted = NO;
	selected = NO;
	unhighlighting = NO;
	self.selectedBackgroundView = nil;
	if (_displayedSelectedBackgroundView != nil)
	{
		[_displayedSelectedBackgroundView removeFromSuperview];
		_displayedSelectedBackgroundView = nil;
	}
	if (_textLabel != nil)
	{
		[_textLabel removeFromSuperview];
		_textLabel = nil;
	}
//	
//	if (_imageView != nil)
//	{
//		[_imageView removeFromSuperview];
//		_imageView = nil;
//	}
	
	self.overlayView = nil;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (UILabel*) textLabel
{
	if (_textLabel == nil)
	{
		_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_textLabel.tag = 444;
		
		UIFont* font = _textLabel.font;
		CGRect frame = _textLabel.frame;
		frame.size.height = font.ascender + font.descender + font.leading;
		_textLabel.frame = frame;

		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.textColor = [UIColor blackColor];
		_textLabel.highlightedTextColor = [UIColor whiteColor];
		
		[self.contentView insertSubview:_textLabel atIndex:0];
		[self setNeedsLayout];
				
		[_textLabel release];
		
		[_textLabel setNeedsDisplay];
		[self setNeedsDisplay];
	}
	
	return _textLabel;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (UIImageView*) imageView
{
	if (_imageView == nil)
	{
		_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_imageView.tag = 555;
		_imageView.contentMode = UIViewContentModeCenter;
		_imageView.clipsToBounds = YES;
		_imageView.backgroundColor = [UIColor clearColor];
		
		[self.contentView insertSubview:_imageView atIndex:0];
		[_imageView release];
		[self setNeedsDisplay];
	}
	
	return _imageView;
}

///////////////////////////////////
//
///////////////////////////////////
- (void)layoutSubviews
{
	CGRect frame = self.frame;
	CGRect workFrame;
	
	backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	if (selectedBackgroundView)
	{
		selectedBackgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	}
	contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	
	CGRect remaining = self.frame;
	remaining.origin.x = 0;
	remaining.origin.y = 0;
	if (_textLabel)
	{
		workFrame.origin.x = 0;
		workFrame.origin.y = frame.size.height - _textLabel.frame.size.height;
		workFrame.size.width = frame.size.width;
		workFrame.size.height = _textLabel.frame.size.height;
		_textLabel.frame = workFrame;
		
		remaining.size.height -= _textLabel.frame.size.height;
	}
	
	if (_imageView)
	{
		_imageView.frame = remaining;
	}

}


///////////////////////////////////
//
///////////////////////////////////
- (void) setSelected:(BOOL) f
{
	[self setSelected: f animated: NO];
}

///////////////////////////////////
//
///////////////////////////////////
- (BOOL) isSelected
{
	return selected;
}

///////////////////////////////////
//
///////////////////////////////////
- (void) setSelected:(BOOL) f animated:(BOOL) animate
{
	if (f)
	{
		if (!highlighted)
		{
			[self highlightCell];
		}
	}
	else 
	{
		[self unhighlightCell:animate];
		[self setNeedsDisplay];
//		if (self.isHighlighted && !unhighlighting)
//		{
//			if (animate)
//			{
//				unhighlighting = YES;
//				[self unhighlightCell];
//			}
//			else 
//			{
//				[self restoreSubviews:self.contentView];
//				[_displayedSelectedBackgroundView removeFromSuperview];
//				_displayedSelectedBackgroundView = nil;
//			}
//		}
	}
	selected = f;
}

///////////////////////////////////
//
///////////////////////////////////
- (UIView*) overlayView
{
	return overlayView;
}

///////////////////////////////////
//
///////////////////////////////////
- (void) setOverlayView:(UIView*) overlay
{
	if (overlayView != nil) 
	{
		[overlayView removeFromSuperview];
		overlayView = nil;
	}

	if (overlay != nil)
	{
		overlayView = overlay;
		CGRect frame = self.contentView.frame;
		frame.origin = CGPointZero;
		overlay.frame = frame;
		[self addSubview:overlay];
	}
}
@end
