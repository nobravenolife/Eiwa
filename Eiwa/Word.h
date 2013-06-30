//
//  Word.h
//  EIWA
//
//  Created by 菅澤 英司 on 2012/12/27.
//  Copyright (c) 2012年 菅澤 英司. All rights reserved.
//

#import <Foundation/Foundation.h>

//英単語と意味のセット
@interface Word : NSObject

@property (nonatomic, assign) NSInteger itemId;   //単語id
@property (nonatomic,   copy) NSString* word;     //英単語
@property (nonatomic,   copy) NSString* mean;     //意味
@property (nonatomic, assign) NSInteger level;    //重要度
@end
