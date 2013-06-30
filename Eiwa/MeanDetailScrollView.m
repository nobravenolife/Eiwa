//
//  MeanDetailScrollView.m
//  Eiwa
//  意味詳細表示の右フリックを親ビューに投げるためだけのクラス
//  Created by 菅澤 英司 on 2013/01/03.
//  Copyright (c) 2013年 菅澤 英司. All rights reserved.
//

#import "MeanDetailScrollView.h"

@implementation MeanDetailScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    return self;
}

//意味詳細に対する右フリックは、親ビューで処理するので親にも投げる処理をしておく
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    [self.nextResponder touchesBegan:touches withEvent:event];
    [super touchesBegan: touches withEvent: event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event

{
    [self.nextResponder touchesEnded:touches withEvent:event];
    [super touchesEnded: touches withEvent: event];
    
}

@end
