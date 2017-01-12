//
//  SwipeTableViewCell.h
//  SwipeTableViewCell
//
//  Created by HeFengyang on 16/2/29.
//  Copyright © 2016年 HFY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^ClickButtonAction)();

@interface SwipeTableViewCell : UITableViewCell

@property (nonatomic, weak) UIView    *swipeContentView;

@property (nonatomic, copy) ClickButtonAction leftAction;
@property (nonatomic, copy) ClickButtonAction rightAction;

+ (void)setLeftTitle:(NSString *)leftTitle
              cellid:(NSString *)cellid;
+ (void)setRightTitle:(NSString *)rightTitle
               cellid:(NSString *)cellid;

@end
