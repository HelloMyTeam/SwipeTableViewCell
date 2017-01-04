//
//  SwipeTableViewCell.m
//  SwipeTableViewCell
//
//  Created by HeFengyang on 16/2/29.
//  Copyright © 2016年 HFY. All rights reserved.
//

#import "SwipeTableViewCell.h"

@interface SwipeTableViewCell ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton  *leftButton;
@property (nonatomic, strong) UIButton  *rightButton;
@property (nonatomic, strong, readwrite) UIView    *swipeContentView;

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
    UIView *swipeContentView = [UIView new];
    swipeContentView.backgroundColor = [UIColor clearColor];
    swipeContentView.frame = self.contentView.bounds;
    swipeContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.swipeContentView = swipeContentView;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(pan:)];
    pan.delegate = self;
    [swipeContentView addGestureRecognizer:pan];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:_leftTitle[self.reuseIdentifier]
                forState:UIControlStateNormal];
    leftButton.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:leftButton];
    self.leftButton = leftButton;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:_rightTitle[self.reuseIdentifier]
                forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:rightButton];
    self.rightButton = rightButton;
    
    self.swipeContentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:swipeContentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftButton.frame = CGRectMake(0, 0, 88, CGRectGetHeight(self.contentView.bounds));
    self.rightButton.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) - 88, 0, 88, CGRectGetHeight(self.contentView.bounds));

}


- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan translationInView:self.swipeContentView];
    
    CGFloat x = fabs(p.x);
    // 轻触cell时也会调用该方法，故加判断
    if (x < 5) {
        // 如果拖到4就停止了，就不会回去了。
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
    [self swipeContentViewX:x];
}
// 重用时恢复
- (void)prepareForReuse {
    [super prepareForReuse];
    [self swipeContentViewX:0];

}
- (void)swipeContentViewX:(CGFloat)x {
    [super setSelected:NO animated:YES];

    CGRect frame = self.swipeContentView.frame;
    frame.origin.x = x;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.swipeContentView.frame = frame;
    }];
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
