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

void dumpViews(UIView* view, NSString *text, NSString *indent) 
{
    Class cl = [view class];
    NSString *classDescription = [cl description];
    while ([cl superclass]) 
    {
        cl = [cl superclass];
        classDescription = [classDescription stringByAppendingFormat:@":%@", [cl description]];
    }
    
    if ([text compare:@""] == NSOrderedSame)
        NSLog(@"%@ %@", classDescription, NSStringFromCGRect(view.frame));
    else
        NSLog(@"%@ %@ %@", text, classDescription, NSStringFromCGRect(view.frame));
    
    for (NSUInteger i = 0; i < [view.subviews count]; i++)
    {
        UIView *subView = [view.subviews objectAtIndex:i];
        NSString *newIndent = [[NSString alloc] initWithFormat:@"  %@", indent];
        NSString *msg = [[NSString alloc] initWithFormat:@"%@%d:", newIndent, i];
        //dumpViews(subView, msg, newIndent);
        [msg release];
        [newIndent release];
    }
}

@implementation UIXGridViewCell

@dynamic selected;
@dynamic highlighted;

@synthesize style = _style;

@dynamic textLabel;
@dynamic imageView;
@dynamic selectionOverlayView;

@synthesize contentView;
@synthesize backgroundView;
@synthesize selectedBackgroundView;
@synthesize overlayOnlySelection;

@synthesize reuseIdentifier = _reuseIdentifier;

//////////////////////////////////////
//
//////////////////////////////////////
- (id)initWithStyle:(UIXGridViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if ((self = [super initWithFrame:CGRectZero]))
	{
		UIView* v;
		
		self.clipsToBounds = YES;
		self.backgroundColor = [UIColor clearColor];
		
		v = [[UIView alloc] initWithFrame:CGRectZero];
		[self addSubview:v];
//		v.tag = 111;
		self.backgroundView = v;
		[v release];
		backgroundView.backgroundColor = [UIColor whiteColor];
		selectedBackgroundView = nil;
		
		v = [[UIView alloc] initWithFrame:CGRectZero];
//		v.tag = 222;
		[self addSubview:v];
		v.backgroundColor = [UIColor clearColor];
		[v release];
		contentView = v;
		
		if (reuseIdentifier != nil)
		{
			_reuseIdentifier = [[NSString stringWithString: reuseIdentifier] retain];
		}
		else 
		{
			_reuseIdentifier = nil;
		}

        overlayOnlySelection = YES;
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
	[savedViewState release];
	[selectedBackgroundView release];
	[backgroundView release];
	[selectionOverlayView release];
    [super dealloc];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (UIXGridView*) gridView
{
    return (UIXGridView*) self.superview;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) highlightSubviews:(UIView*) view savingStateIn:(NSMutableDictionary*) savedStateDict
{
	BOOL hasHighlight;
	
    NSInteger ndx=0;
    
	for (ndx = 0; ndx < [view.subviews count]; ++ndx)
	{
		UIView* subview = [view.subviews objectAtIndex:ndx];
		
		//highlight
		NSMutableDictionary* stateDict = [NSMutableDictionary dictionary];

		hasHighlight = NO;
		
		if ([subview respondsToSelector:@selector(isHighlighted)] && [subview respondsToSelector:@selector(setHighlighted:)])
		{
			[stateDict setObject:[NSNumber numberWithBool:(BOOL)[((id) subview) isHighlighted]] forKey:@"h"];
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
			[((id) subview) setHighlighted:YES];
//            [subview setNeedsDisplay];
//
//            if ([[subview class] isEqual:[UILabel class]])
//            {
//                UILabel* l = (UILabel*) subview;
//                UIColor* c = l.highlightedTextColor;
//                BOOL h = l.highlighted;
//                int x = 999;
//                //l.textColor = [UIColor whiteColor];
//            }
            
		}
		 
		 subview.opaque = NO;
		 subview.backgroundColor = [UIColor clearColor];
		
		[self highlightSubviews:subview savingStateIn:savedStateDict];
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) highlightCell: (BOOL) animated
{

	// note: animation not currently supported
	
	[savedViewState release];
	savedViewState = [[NSMutableDictionary dictionary] retain];
	[self highlightSubviews:contentView savingStateIn: savedViewState];
	[contentView setNeedsDisplay]; //???
    
	UIColor* bgColor;
    
	if (selectedBackgroundView == nil)
	{
		_displayedSelectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		bgColor = [[self gridView] selectionBackgroundColorForCell:self];
		_displayedSelectedBackgroundView.backgroundColor = bgColor;
	}
	else 
	{
		_displayedSelectedBackgroundView = selectedBackgroundView;
	}
    
	CGRect frame;
	frame.size = self.frame.size;
	frame.origin = CGPointMake(0,0);
	_displayedSelectedBackgroundView.frame = frame;

	[self insertSubview:_displayedSelectedBackgroundView aboveSubview:backgroundView];

	highlighted = YES;
    
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
			BOOL hl = [highlightState boolValue];
			[((id) subview) setHighlighted:hl];
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
		if (highlightState != nil && [subview respondsToSelector:@selector(setHighlighted:)])
		{
			[(id) subview setHighlighted:[highlightState boolValue]];
		}
		
		NSNumber* opaqueState = [stateDict objectForKey:@"o"];
		subview.opaque = [opaqueState boolValue];
		
		UIColor* bc = [stateDict objectForKey:@"bc"];
		subview.backgroundColor = bc;
	}

	[savedViewState release];
	savedViewState = nil;
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
		[UIView setAnimationDuration:0.15];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		 _displayedSelectedBackgroundView.alpha = 0.0;
		 [UIView commitAnimations];
	}
	else 
	{
		[self restoreSubviews:contentView];
		highlighted = NO;

		[_displayedSelectedBackgroundView removeFromSuperview];
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
//- (void) unhighlightCell
//{
//	[self restoreSubviews:contentView];
//}


//////////////////////////////////////
//
//////////////////////////////////////
- (void) unhighlightCell:(BOOL) animated
{
	// note animation not currently supported
	
//	NSLog(@"unhighlightCell %d",animated);
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
//		self.highlighted = NO;
//		[self unhighlightSubviews:contentView];
//		[self restoreSubviews:contentView];
//		[savedViewState release];
//		savedViewState = nil;
//		self.highlighted = NO;
		
#if 0		
		[_displayedSelectedBackgroundView removeFromSuperview];
//		v =  _displayedSelectedBackgroundView.superview;
		_displayedSelectedBackgroundView = nil;
		if (selectedBackgroundView != nil)
		{
			selectedBackgroundView.alpha = 1.0;
		}
#endif		
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)prepareForReuse
{
	[self setSelected:NO animated:NO];
	[self setHighlighted:NO animated:NO];
	unhighlighting = NO;
    
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
	
	if (_imageView != nil)
	{
		[_imageView removeFromSuperview];
		_imageView = nil;
	}
	
    if (_displayedSelectionOverlayView != nil)
    {
        [_displayedSelectionOverlayView removeFromSuperview];
        _displayedSelectionOverlayView = nil;
    }
}

//////////////////////////////////////
//
//////////////////////////////////////
- (UILabel*) textLabel
{
	if (_textLabel == nil)
	{
		_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		UIFont* font = _textLabel.font;
		CGRect frame = _textLabel.frame;
		frame.size.height = font.ascender + font.descender + font.leading;
		_textLabel.frame = frame;

		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.textColor = [UIColor blackColor];
		_textLabel.highlightedTextColor = [UIColor whiteColor];
		
		[self.contentView insertSubview:_textLabel atIndex:0];
				
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
    [super layoutSubviews];
    
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
    //dumpViews(self, @"laidout", @" ");
}


///////////////////////////////////
//
///////////////////////////////////
- (void) selectCell: (BOOL) animate
{
	selected = YES;
    UIView* overlayView;
    
    if (selectionOverlayView == nil)
    {
        overlayView = [[UIXGridViewSelectionOverlayView alloc] init];
        //alloc default
    }
    else
    {
        overlayView = selectionOverlayView;
    }
    
    _displayedSelectionOverlayView = overlayView;
    _displayedSelectionOverlayView.frame = self.bounds;
    [self addSubview:_displayedSelectionOverlayView];
    
//    dumpViews(self, @"select", @"  ");
    
#if 0
	// note: animation on selection not currently supported
	
	UIColor* bgColor;
	
	if (selectedBackgroundView == nil)
	{
		_displayedSelectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		bgColor = [[self gridView] selectionBackgroundColorForCell:self];
		_displayedSelectedBackgroundView.backgroundColor = bgColor;
	}
	else 
	{
		_displayedSelectedBackgroundView = selectedBackgroundView;
	}
	
	[self insertSubview:_displayedSelectedBackgroundView aboveSubview:backgroundView];
	
	CGRect frame;
	frame.size = self.frame.size;
	frame.origin = CGPointMake(0, 0);
	_displayedSelectedBackgroundView.frame = frame;
	
	selected = YES;
	
	self.highlighted = YES;
#endif    
}

///////////////////////////////////
// 
///////////////////////////////////
- (void) unselectCell: (BOOL) animated
{
	selected = NO;
    if (_displayedSelectionOverlayView != nil)
    {
        [_displayedSelectionOverlayView removeFromSuperview];
        _displayedSelectionOverlayView = nil;
    }
    
//    dumpViews(self, @"unselect", @"  ");
    
#if 0    
	if (animated)
	{
		[UIView beginAnimations:@"backgroundFade1" context:nil];
		[UIView setAnimationDuration:0.15];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		_displayedSelectedBackgroundView.alpha = 0.5;
		[UIView commitAnimations];
	}
	else 
	{
		[self unhighlightSubviews:contentView];
		[self restoreSubviews:contentView];
		highlighted = NO;
		
		[_displayedSelectedBackgroundView removeFromSuperview];
		_displayedSelectedBackgroundView = nil;
		if (selectedBackgroundView != nil)
		{
			selectedBackgroundView.alpha = 1.0;
		}
		selected = NO;	//does not use accessor as it causes a cycle	
		self.highlighted = NO;
	}
#endif    
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
		[self selectCell: animate];
	}
	else 
	{
		[self unselectCell: animate];
	}
	
//	selected = f;
}

///////////////////////////////////
//
///////////////////////////////////
- (void) setHighlighted:(BOOL) f animated:(BOOL) animated
{
	if (f)
	{
		[self highlightCell: animated];
	}
	else 
	{
		[self unhighlightCell: animated];
	}

}

///////////////////////////////////
//
///////////////////////////////////
- (void) setHighlighted:(BOOL) f
{
	[self setHighlighted: f animated: NO];
}

///////////////////////////////////
//
///////////////////////////////////
- (BOOL) isHighlighted
{
	return highlighted;
}


///////////////////////////////////
//
///////////////////////////////////
- (UIView*) selectionOverlayView
{
	return selectionOverlayView;
}

///////////////////////////////////
//
///////////////////////////////////
- (void) setSelectionOverlayView:(UIView*) overlay
{
	if (selectionOverlayView != nil) 
	{
		[selectionOverlayView removeFromSuperview];
		selectionOverlayView = nil;
	}

	if (selectionOverlayView != nil)
	{
		selectionOverlayView = overlay;
		CGRect frame = self.contentView.frame;
		frame.origin = CGPointZero;
		overlay.frame = frame;
		[self addSubview:overlay];
	}
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.highlighted)
    {
        [self setHighlighted:NO animated:YES]; 

        switch ([[self gridView] selectionStyle])
        {
            case UIXGridViewSelectionStyleSingle:
            {
                // !!!:get rid of old selection
                [[self gridView] clearSelection];
                [self setSelected:YES animated:YES];
                [[self gridView] informDidSelectCell:self];
            }
                break;
                
            case UIXGridViewSelectionStyleMultiple:
            {
                // !!!:need to toggle selection
                BOOL newState = !self.selected;
                [self setSelected:newState animated:YES];
                if (newState == YES)
                {
                    [[self gridView] informDidSelectCell:self];
                }
                else
                {
                    [[self gridView] informDidUnselectCell:self];
                }
            }
                break;
                
            case UIXGridViewSelectionStyleMomentary:
            {
                [[self gridView] informDidSelectCell:self];
            }
                break;
        }
        // ???: should this logic be moved into setSelection?  Yes because I need to account programatically
        //if single
        //   undo old selection
        //endif
        //set selected
    }
    
    
#if 0    
	if (self.highlighted /*&& !unhighlighting*/)
	{
		UIXGridView* grid = (UIXGridView*) self.superview;
		
		//		[grid informWillSelectCell:self];
		//		[self unhighlightCell:NO];
		[self setNeedsDisplay];
		
		[grid informDidSelectCell:self];
	}
#endif    
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    if (!self.highlighted)
    {
        [self setHighlighted:YES animated:YES];
    }    
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.highlighted)
    {
        [self setHighlighted:NO animated:YES];
    }
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.highlighted)
    {
        [self setHighlighted:NO animated:YES];
    }
}

@end

#pragma mark -
#pragma mark -
#pragma mark UIXGridViewSelectionOverlayView

@implementation UIXGridViewSelectionOverlayView

//////////////////////////////////////
//
//////////////////////////////////////
- (id) init
{
    self = [super initWithFrame:CGRectMake(0, 0, 50, 50)];
    if (self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        
        icon = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        icon.backgroundColor = [UIColor redColor];
        icon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:icon];
        [icon release];
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}
@end

@implementation UIXGridViewCheckView
#pragma mark -
#pragma mark UIXGridViewCheckView
//////////////////////////////////////
//
//////////////////////////////////////
- (id) init
{
    self = [super initWithFrame:CGRectMake(0, 0, 30, 30)];
    if (self != nil)
    {
        
    }
    
    return self;
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void) drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor blackColor] set];
    
    CGContextMoveToPoint(context, 5, 15);
    CGContextAddLineToPoint(context, 15, 25);    
    CGContextAddLineToPoint(context, 25, 5);

    CGContextClosePath(context);  
    CGContextDrawPath(context, kCGPathStroke);	

}
@end
