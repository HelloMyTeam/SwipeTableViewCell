//
//  SwipeTableViewCell.m
//  SwipeTableViewCell
//
//  Created by HeFengyang on 16/2/29.
//  Copyright © 2016年 HFY. All rights reserved.
//

#import "SwipeTableViewCell.h"

@interface SwipeTableViewCell ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;
@property (nonatomic, weak) IBOutlet UIView *myContentView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;

@end

@implementation SwipeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.myContentView.backgroundColor = [UIColor yellowColor];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [self.myContentView addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan {

    CGPoint p = [pan translationInView:self.myContentView];
   

    CGFloat x = fabsf(p.x);
    // 轻触cell时也会调用该方法，故加判断
    if (x < 5) {
        return;
    }
    // 此刻在拖动
    if (pan.state == UIGestureRecognizerStateChanged) {
        // 88是自己设置的，这儿设置的是button的宽度
        if (x > 88) {
            return;
        }
    }
    // 拖地结束
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 结束后大于44，判定为拖动成功，否则失败，成功了分左右
        if (x >= 44 ) {
            if (p.x > 0) {
                x = 88;
            } else {
                x = -88;
            }
        } else {
            x = 0;
        }
    } else {
        // 下面设置时用的x的值，这儿得用原始的
        x = p.x;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        _left.constant = x;
        _right.constant = -x;
        [pan.view layoutIfNeeded]; // 这样效果不生硬
    }];
}
// 重用时恢复
- (void)prepareForReuse
{
    [super prepareForReuse];
    _right.constant = 0;
    _left.constant = 0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
// 不设置，tableview不能滑动，该方法返回YES时，意味着所有相同类型的手势辨认都会得到处理。
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
