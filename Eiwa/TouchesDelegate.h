//
//  TouchDelegate.h
//  Eiwa
//
//  Created by 菅澤 英司 on 2012/12/29.
//  Copyright (c) 2012年 菅澤 英司. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TouchesDelegate

@optional
- (void)view:(UIView*)view touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)view:(UIView*)view touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)view:(UIView*)view touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)view:(UIView*)view touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event;

@end