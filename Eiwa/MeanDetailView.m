//
//  MeanDetailView.m
//  Eiwa
//  意味の詳細表示
//  Created by 菅澤 英司 on 2012/12/31.
//  Copyright (c) 2012年 菅澤 英司. All rights reserved.
//

#import "MeanDetailView.h"
#import "MeanDetailScrollView.h"

@interface MeanDetailView ()

@property (nonatomic)   CGRect        defaultFrame;               // 初期のポジションを保存する
@property (nonatomic, retain)  MeanDetailScrollView* meanScroll;  //単語の意味のスクロール


@end

@implementation MeanDetailView

@synthesize defaultFrame,wordLabel,meanLabel,meanScroll;


//意味詳細ビューの初期化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        defaultFrame = frame;
        self.backgroundColor = [UIColor viewFlipsideBackgroundColor]; //背景色
        
        //英単語
        wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 40)];
        wordLabel.backgroundColor = [UIColor clearColor];
        wordLabel.textColor = [UIColor whiteColor];
        wordLabel.font =[UIFont fontWithName:@"HiraMinProN-W6" size:26.0f];
        wordLabel.adjustsFontSizeToFitWidth =YES;                //単語が長い場合fontサイズ縮小
        [self addSubview:wordLabel];
        
        //英単語意味
        meanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,defaultFrame.size.width-20, 200)];
        
        meanLabel.backgroundColor = [UIColor clearColor];
        meanLabel.textColor = [UIColor whiteColor];
        meanLabel.font =[UIFont fontWithName:@"HiraMinProN-W3" size:14];
        meanLabel.lineBreakMode = NSLineBreakByWordWrapping; //ラベルの大きさに合わせて折り返し表示
            
        meanScroll = [[MeanDetailScrollView alloc] initWithFrame:
        CGRectMake(15, 50, meanLabel.frame.size.width, defaultFrame.size.height-50)];
        
        meanScroll.scrollEnabled = YES;
        meanScroll.delaysContentTouches = NO;
        
        [meanScroll addSubview:meanLabel];
        [self addSubview:meanScroll];
                
    }
    
    return self;
}

//英単語の意味詳細表示
-(void)showMeanDetail:(NSString*)wordTitle meanDetail:(NSString*)meanDetail X:(int)x
{
    
    wordLabel.text = wordTitle;
    meanLabel.text = meanDetail;
    
    
    //前回の文字数によってはラベルの横が縮まってる可能性があるのでもとに戻す
    [meanLabel setFrame:CGRectMake(meanLabel.frame.origin.x, meanLabel.frame.origin.y,
                                         defaultFrame.size.width-20, meanLabel.frame.size.height)];
    
    [meanLabel setNumberOfLines:0];
    [meanLabel sizeToFit];
    
    [meanScroll setContentSize:meanLabel.frame.size];
    
    [meanScroll setContentOffset:CGPointMake(0, 0) animated:NO]; //以前スクロールしてたら一番上に戻す

    
    // 左からアニメーションで出現
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2]; //0.2秒かける
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    self.frame = CGRectMake(x, 0, defaultFrame.size.width, defaultFrame.size.height); // 画面内へ動かす
    [UIView commitAnimations];
    
    
}



//英単語の意味詳細を閉じる(ビューの位置を元の場所に戻す)
-(void)closeMeanDetail
{
    if(self.frame.origin.x != defaultFrame.origin.x){ //意味詳細が開いていれば閉じる
        // 右へアニメーションで消える
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2]; //0.2秒かける
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        self.frame = defaultFrame;

        [UIView commitAnimations];
    }  
}


@synthesize nextResponderMeanDetailView;

//タッチ時の処理を親のビューに投げる
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [nextResponderMeanDetailView touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [nextResponderMeanDetailView touchesEnded:touches withEvent:event];
}


@end