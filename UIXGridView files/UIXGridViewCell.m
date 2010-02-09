//
//  UIXGridViewCell.m
//  GridView
//
//  Created by gumbright on 8/11/09.
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

#import "UIXGridViewCell.h"
#import "UIXGridView.h"

@implementation UIXGridViewCell

@synthesize contentView;
@synthesize label;
@synthesize imageView;
@synthesize selected;
@synthesize reuseIdentifier;

#define LABEL_HEIGHT 21
#define BORDER_SIZE 3
#define INITIAL_HEIGHT 480
#define INIIAL_WIDTH 320

///////////////////////////////////
//
///////////////////////////////////
//- (id) init
- (id)initWithStyle:(UIXGridViewCellStyle)style reuseIdentifier:(NSString *)reuseId;
{

	if (self = [super initWithFrame:CGRectZero])
	{
		self.clipsToBounds = YES;
		CGRect frame;
		self.backgroundColor = [UIColor clearColor];
		
		frame.origin.x = frame.origin.y = 0;
		frame.size.width = INIIAL_WIDTH;
		frame.size.height = INITIAL_HEIGHT;
		UIView* cv = [[UIView alloc] initWithFrame:frame];
		contentView = cv;
		[self addSubview:cv];
		
		frame.origin.x = BORDER_SIZE;
		frame.origin.y = BORDER_SIZE;
		frame.size.width = INIIAL_WIDTH - (BORDER_SIZE * 2);
		frame.size.height = INITIAL_HEIGHT - (LABEL_HEIGHT + (BORDER_SIZE * 2)) ;
		imageView = [[UIImageView alloc] initWithFrame:frame];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.tag = 2;
		imageView.autoresizingMask =  UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
		[contentView addSubview:imageView];
		
		frame.origin.x = BORDER_SIZE;
		frame.origin.y = INITIAL_HEIGHT - (LABEL_HEIGHT + BORDER_SIZE);
		frame.size.height = LABEL_HEIGHT;
		frame.size.width = INIIAL_WIDTH - (BORDER_SIZE * 2);
		label = [[UILabel alloc] initWithFrame:frame];
		label.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		label.tag = 1;
		label.textAlignment = UITextAlignmentCenter;
		label.backgroundColor = [UIColor clearColor];
		[contentView addSubview:label];
		
		reuseIdentifier = [[NSString stringWithString: reuseId] retain];
	}
	
	return self;
}

///////////////////////////////////
//
///////////////////////////////////
- (void) dealloc
{
	[reuseIdentifier release];
	[super dealloc];
}

///////////////////////////////////
//
///////////////////////////////////
- (void)layoutSubviews
{
	if (label.text == nil)
	{
		label.hidden = YES;
	}
	else	
	{
		label.hidden = NO;
	}
	CGRect frame = self.frame;
		
	CGRect workFrame = frame;
	workFrame.origin.x = 0;
	workFrame.origin.y = 0;
		
	contentView.frame = workFrame;
	
	workFrame.origin.x = BORDER_SIZE;
	workFrame.origin.y = frame.size.height - (BORDER_SIZE + LABEL_HEIGHT);
	workFrame.size.width = frame.size.width - (BORDER_SIZE * 2);
	workFrame.size.height = LABEL_HEIGHT;
	label.frame = workFrame;
	
	workFrame.origin.x = BORDER_SIZE;
	workFrame.origin.y = BORDER_SIZE;
	workFrame.size.width = frame.size.width - (BORDER_SIZE * 2);
	workFrame.size.height = frame.size.height - ((BORDER_SIZE * 2) + LABEL_HEIGHT);
	imageView.frame = workFrame;
	
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"UIXGridViewCell - touchesEnded %@",self);
	UIXGridView* grid = (UIXGridView*) self.superview;
	[grid cellReleased:self];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"UIXGridViewCell - touchesBegan %@",self);
	UIXGridView* grid = (UIXGridView*) self.superview;
	[grid cellTouched: self];
}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UIXGridView* grid = (UIXGridView*) self.superview;
	[grid cellTouchMoved:self withEvent:event];
}


//////////////////////////////////////
//
//////////////////////////////////////
//- (void)drawRect:(CGRect)rect
//{	
//	CGRect frame = self.frame;
//	[super drawRect:rect];
//}

//////////////////////////////////////
//
//////////////////////////////////////
- (void)prepareForReuse
{
	label.text = @"";
	imageView.image = nil;
	selected = NO;
}

@end
