//
//  SwipeTableViewCell.m
//  SwipeTableViewCell
//
//  Created by HeFengyang on 16/2/29.
//  Copyright © 2016年 HFY. All rights reserved.
//

// button的隐藏和显示还有一点问题
// 考虑按钮自己加在cell上

#import "SwipeTableViewCell.h"

@interface SwipeTableViewCell ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton  *leftButton;
@property (nonatomic, strong) UIButton  *rightButton;
//@property (nonatomic, strong, readwrite) UIView    *swipeContentView;

@end

@implementation SwipeTableViewCell

static NSMutableDictionary *_leftTitle;
static NSMutableDictionary *_rightTitle;


+ (void)setLeftTitle:(NSString *)leftTitle
              cellid:(NSString *)cellid {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _leftTitle = [NSMutableDictionary dictionary];
    });
    _leftTitle[cellid] = leftTitle;
}
+ (void)setRightTitle:(NSString *)rightTitle
               cellid:(NSString *)cellid {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _rightTitle = [NSMutableDictionary dictionary];
    });
    _rightTitle[cellid] = rightTitle;
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup {
//    UIView *swipeContentView = [UIView new];
//    swipeContentView.backgroundColor = [UIColor clearColor];
//    swipeContentView.frame = self.contentView.bounds;
//    swipeContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.swipeContentView = self.contentView;
    UIView *swipeContentView = self.contentView;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(pan:)];
    pan.delegate = self;
    [swipeContentView addGestureRecognizer:pan];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:_leftTitle[self.reuseIdentifier]
                forState:UIControlStateNormal];
    leftButton.backgroundColor = [UIColor greenColor];
    [self insertSubview:leftButton belowSubview:self.contentView];
    self.leftButton = leftButton;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:_rightTitle[self.reuseIdentifier]
                forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor redColor];
    [self insertSubview:rightButton belowSubview:self.contentView];
    self.rightButton = rightButton;
    
    self.swipeContentView.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:swipeContentView];
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftButton.frame = CGRectMake(0, 0, 88, CGRectGetHeight(self.contentView.bounds));
    self.rightButton.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) - 88, 0, 88, CGRectGetHeight(self.contentView.bounds));
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan translationInView:self.swipeContentView];
//    NSLog(@"%@",@(p.y));
    CGFloat x = fabs(p.x);
    CGFloat y = fabs(p.y);
//    if (y > x) {
//        return;
//    }
    if ((y != 0 && x < 15) ||  y > x) {
        // 上滑的时候重置
        [self swipeContentViewX:0 animated:NO];
        return;
    }
    // 轻触cell时也会调用该方法，故加判断
    if (x < 5) {
        // 如果拖到4就停止了，就不会回去了,如果已经停止拖动，重置。
        if (pan.state == UIGestureRecognizerStateEnded) {
            [self swipeContentViewX:0 animated:NO];
        }
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
    [self swipeContentViewX:x animated:YES];
}
// 重用时恢复
- (void)prepareForReuse {
    [super prepareForReuse];
    [self swipeContentViewX:0 animated:NO];

}
- (void)swipeContentViewX:(CGFloat)x animated:(BOOL)animated{
    [super setSelected:NO animated:YES];
    self.leftButton.hidden = x == 0;
    self.rightButton.hidden = x == 0;
    CGRect frame = self.swipeContentView.frame;
    frame.origin.x = x;
    
    [UIView animateWithDuration:(animated ? 0.1 : 0) animations:^{
        self.swipeContentView.frame = frame;
    }];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (self.selectionStyle == UITableViewCellSelectionStyleNone) {
        return;
    }
// 有待研究
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    if (fabs(self.swipeContentView.frame.origin.x) <= 5) {
        [super setHighlighted:highlighted animated:animated];
    } else {
        [super setHighlighted:NO animated:NO];

    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    // 选中之后恢复
    [self swipeContentViewX:0 animated:YES];
    if (self.selectionStyle == UITableViewCellSelectionStyleNone) {
        return;
    }
    // 为了取消选中
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     
        if (self.selected) {
            [super setSelected:NO animated:NO];

        }
    });
    // Configure the view for the selected state
}
// 不设置，tableview不能滑动，该方法返回YES时，意味着所有相同类型的手势辨认都会得到处理。
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 判断当前是否已经开始滑动，如果开始滑动，拦截tableview
    return fabs(self.swipeContentView.frame.origin.x) <= 5;
}

@end
