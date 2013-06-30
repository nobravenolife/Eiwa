//
//  WordInputField.m
//  Eiwa
//  英単語入力欄
//  Created by 菅澤 英司 on 2013/01/02.
//  Copyright (c) 2013年 菅澤 英司. All rights reserved.
//

#import "WordInputField.h"

@interface WordInputField ()



@end

@implementation WordInputField

@synthesize inputLabel,inputWord;


- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {

        
        inputWord = @"";
        
        
        self.backgroundColor = [UIColor whiteColor];
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.textColor = [UIColor clearColor];    //あえてここでは表示しない
        self.textAlignment = NSTextAlignmentLeft;
        self.font = [UIFont fontWithName:@"Helvetica" size:22];
        self.placeholder = @"";
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.returnKeyType = UIReturnKeyDone;
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.keyboardAppearance = UIKeyboardAppearanceAlert;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.secureTextEntry = YES;
        
        //入力されたワードの表示。なぜわざわざ別ラベルにするかといえば、
        //入力キーボードを英語限定にするためにパスワード入力モードにする必要があり
        //パスワードモードにすると入力文字がマスクされてしまうためにその上から表示する
        
        CGRect rectLabel = CGRectMake(frame.origin.x+10, frame.origin.y+2, frame.size.width-40, frame.size.height-5);
        
        inputLabel = [[UILabel alloc]initWithFrame:rectLabel];
        inputLabel.backgroundColor = [UIColor whiteColor];
        inputLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
        inputLabel.adjustsFontSizeToFitWidth = YES;
       // [self addSubview:inputLabel];  //ここでaddするとカーソルが消えないため親ビューでadd
    
    }
    return self;
}

-(void)setInputText:(NSString*)inputText  //入力された単語。ラベルにもセット
{
    inputWord = inputText;
    self.text = inputText;
    inputLabel.text = inputText;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {  //１文字でも入力があればコピペのバーを表示させない
    if ((inputWord.length>0)&&(action == @selector(paste:) || @selector(select:)))
    {
        return NO;
    }
        
    return [super canPerformAction:action withSender:sender];
}

@end
