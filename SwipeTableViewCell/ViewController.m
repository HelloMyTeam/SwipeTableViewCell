//
//  ViewController.m
//  SwipeTableViewCell
//
//  Created by HeFengyang on 16/2/29.
//  Copyright © 2016年 HFY. All rights reserved.
//

#import "ViewController.h"
#import "TestSwipeTableViewCell.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *data;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    // Do any additional setup after loading the view, typically from a nib.
    self.data = [NSMutableArray array];
    NSInteger numberOfItems = 20;
    for (NSInteger i = 1; i <= numberOfItems; i++) {
        NSString *item = [NSString stringWithFormat:@"Item #%ld", (long)i];
        [_data addObject:item];
    }
    [TestSwipeTableViewCell setLeftTitle:@"完成" cellid:@"test"];
    [TestSwipeTableViewCell setRightTitle:@"删除" cellid:@"test"];
    [self.tableView registerClass:[TestSwipeTableViewCell class] forCellReuseIdentifier:@"test"];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwipeTableViewCell" forIndexPath:indexPath];
    TestSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    cell.myTextLabel.text = _data[indexPath.row];
    if (cell.leftAction == NULL) {
        cell.leftAction = ^{
            NSLog(@"点击左");
        };
    }
    if (cell.rightAction == NULL) {
        cell.rightAction = ^{
            NSLog(@"点击右");
        };
    }
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
