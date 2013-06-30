//
//  EiwaTextField.m
//  Eiwa
//
//  Created by 菅澤 英司 on 2013/01/02.
//  Copyright (c) 2013年 菅澤 英司. All rights reserved.
//

#import "EiwaTextField.h"

@implementation EiwaTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) drawTextInRect:(CGRect)rect {
    self.secureTextEntry = NO;
    //[super drawTextInRect:rect];
}


@end
