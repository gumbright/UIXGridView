//
//  UIXGridViewCell.h
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

#import <Foundation/Foundation.h>


@interface UIXGridViewCell : UIView 
{
	UIView* contentView;
	UILabel* label;
	UIImageView* imageView;
	
	BOOL selected;
	NSString* reuseIdentifier;
}

@property (readonly) UIView* contentView;
@property (readonly) UILabel* label;
@property (readonly) UIImageView* imageView;
@property (assign,getter=isSelected) BOOL selected;
@property (nonatomic, readonly, copy) NSString* reuseIdentifier;

typedef enum {
	UIGridViewCellStyleDefault
} UIGridViewCellStyle;

- (id)initWithStyle:(UIGridViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)prepareForReuse;


@end
