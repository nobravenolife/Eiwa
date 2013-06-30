//
//  WordInputField.h
//  Eiwa
//
//  Created by 菅澤 英司 on 2013/01/02.
//  Copyright (c) 2013年 菅澤 英司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordInputField : UITextField

@property (nonatomic, retain) UILabel*            inputLabel;        // 入力された文字を表示するラベル
@property (nonatomic, retain) NSString*           inputWord;         // ユーザが入力したワード

- (void)setInputText:(NSString*)inputText;

@end
