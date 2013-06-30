//
//  MeanDetailView.h
//  Eiwa
//
//  Created by 菅澤 英司 on 2012/12/31.
//  Copyright (c) 2012年 菅澤 英司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeanDetailView : UIView

@property(nonatomic,retain) UIResponder* nextResponderMeanDetailView;

@property (nonatomic, retain)  UILabel* wordLabel;  //単語表示
@property (nonatomic, retain)  UILabel* meanLabel;  //単語の意味表示

- (void)closeMeanDetail;
- (void)showMeanDetail:(NSString*)wordTitle meanDetail:(NSString*)meanDetail X:(int)x;

@end
