//
//  DemoViewController.m
//  Demo
//
//  Created by swp_song on 16/5/12.
//  Copyright © 2016年 swp_song. All rights reserved.
//

#import "DemoViewController.h"

#import <MJRefresh/MJRefresh.h>

#import "SwpHeaderRefresh.h"

static NSString * const kDemoCellID = @"kDemoCellID";

@interface DemoViewController () <UITableViewDataSource>

@property (nonatomic, strong) UITableView *demoTableView;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.demoTableView];
    self.demoTableView.mj_header = [SwpHeaderRefresh headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshingData)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)headerRereshingData {
    
    // 只是 单纯 的展示 刷新 样式 不做 数据测处理
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf endRefresh];
    });
}

- (void)endRefresh {
    [self.demoTableView.mj_header endRefreshing];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDemoCellID];
    cell.textLabel.text   = [NSString stringWithFormat:@"swpRefreshLayer_%ld", (long)indexPath.row];
    return cell;
}

- (UITableView *)demoTableView {
    
    
    if (!_demoTableView) {
        _demoTableView            = [[UITableView alloc] initWithFrame:self.view.frame];
        _demoTableView.dataSource = self;
        [_demoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDemoCellID];
    }
    return _demoTableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
