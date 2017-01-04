//
//  SwipeTableViewCell.h
//  SwipeTableViewCell
//
//  Created by HeFengyang on 16/2/29.
//  Copyright © 2016年 HFY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SwipeTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UIView    *swipeContentView;

+ (void)setLeftTitle:(NSString *)leftTitle
              cellid:(NSString *)cellid;
+ (void)setRightTitle:(NSString *)rightTitle
               cellid:(NSString *)cellid;

@end
