//
//  EiwaViewController.h
//  EIWA
//
//  Created by 菅澤 英司 on 2012/12/25.
//  Copyright (c) 2012年 菅澤 英司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EiwaViewController : UIViewController<UITextFieldDelegate,
UITableViewDelegate,UITableViewDataSource>

- (void)applicationWillEnterForeground;

@end
