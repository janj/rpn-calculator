//
//  RPNTextField.m
//  RPNCalculator
//
//  Created by Jan Jirout on 6/18/14.
//  Copyright (c) 2014 Jan Jirout. All rights reserved.
//

#import "RPNTextField.h"

@implementation RPNTextField

#define CONTENT_INSET 10

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , CONTENT_INSET , CONTENT_INSET );
}

// text position, same as placeholder position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
