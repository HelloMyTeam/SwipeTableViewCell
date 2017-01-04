//
//  TestSwipeTableViewCell.m
//  SwipeTableViewCell
//
//  Created by HeFengyang on 2017/1/4.
//  Copyright © 2017年 HFY. All rights reserved.
//

#import "TestSwipeTableViewCell.h"

@implementation TestSwipeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (UILabel *)myTextLabel {
    if (_myTextLabel == nil) {
        _myTextLabel = [[UILabel alloc] initWithFrame:self.swipeContentView.bounds];
        _myTextLabel.textAlignment = NSTextAlignmentCenter;
        _myTextLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _myTextLabel.backgroundColor = [UIColor yellowColor];
        
        [self.swipeContentView insertSubview:_myTextLabel atIndex:100];
    }
    return _myTextLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
