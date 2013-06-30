//
//  DictionaryDB.h
//  EIWA
//
//  Created by 菅澤 英司 on 2012/12/27.
//  Copyright (c) 2012年 菅澤 英司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Word;

/**
 * 英和辞書へのアクセス
 */

@interface DictionaryDB : NSObject

- (NSMutableArray*)searchWords:(NSString*)searchWord;

@end
