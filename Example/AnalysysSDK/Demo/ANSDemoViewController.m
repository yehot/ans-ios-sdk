//
//  ANSDemoViewController.m
//  AnalysysSDK-iOS
//
//  Created by SoDo on 2019/3/13.
//  Copyright © 2019 shaochong du. All rights reserved.
//

#import "ANSDemoViewController.h"
#import <AnalysysSDK/AnalysysAgent.h>
#import "ANSDemoTableViewCell.h"
#import "UnitTestCase.h"
#import "ANSSearchTableViewController.h"

@interface ANSDemoViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,copy)NSArray* dataSource;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ANSDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"列表测试";
    self.navigationItem.titleView = [self customerTitleView];

    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
//    self.tableView.tableHeaderView = [self headerView];
//    if(@available(iOS 11.0, *)) {
//        self.navigationItem.searchController = self.searchController;
//        self.navigationItem.hidesSearchBarWhenScrolling = YES;
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
        self.tableView.tableHeaderView = self.searchController.searchBar;
        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
}

- (UIView *)headerView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    view.backgroundColor = [UIColor redColor];
    return view;
}



- (UIView *)customerTitleView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 30);
    [btn setBackgroundColor:[UIColor magentaColor]];
    [btn setTitle:@"自定义标题" forState:UIControlStateNormal];
    [bgView addSubview:btn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 80, 30)];
    label.text = @"列表测试";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor orangeColor];
    [bgView addSubview:label];

    return bgView;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        ANSSearchTableViewController *searchVC = [[ANSSearchTableViewController alloc] init];
        _searchController = [[UISearchController alloc] initWithSearchResultsController:searchVC];
        _searchController.delegate = searchVC;
        _searchController.searchResultsUpdater = searchVC;
        _searchController.searchBar.frame=CGRectMake(0,0,_searchController.searchBar.frame.size.width,44.0);
    }
    return _searchController;
}

#pragma mark -----------------搜索栏代理--------------------

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // 修改UISearchBar右侧的取消按钮文字颜色及背景图片
    for (id searchbuttons in [[searchBar subviews][0]subviews]) //只需在此处修改即可
        if ([searchbuttons isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton *)searchbuttons;
            // 修改文字颜色
            [cancelButton setTitle:@"取消"forState:UIControlStateNormal];
        }
}

#pragma mark  -------searchbarDelegate------
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

#pragma mark - source data

-(NSArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray* mutDataArr = [NSMutableArray array];
        [mutDataArr addObject:self.trackArr];
        [mutDataArr addObject:self.pageViewArr];
        [mutDataArr addObject:self.aliasArr];
        [mutDataArr addObject:self.superPropertyArr];
        [mutDataArr addObject:self.profileSetArr];
        [mutDataArr addObject:self.profileSetOnceArr];
        [mutDataArr addObject:self.profileIncrementArr];
        [mutDataArr addObject:self.profileAppendArr];
        
        _dataSource = mutDataArr.copy;
    }
    return _dataSource;
}

- (NSArray *)aliasArr {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
    for (int i = 0; i < 5; i++) {
        NSString *selectorStr = [NSString stringWithFormat:@"alias_%d",i];
        [arr addObject:selectorStr];
    }
    return arr.copy;
}

- (NSArray *)superPropertyArr {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i < 6; i++) {
        NSString *selectorStr = [NSString stringWithFormat:@"superProperty_%d",i];
        [arr addObject:selectorStr];
    }
    return arr.copy;
}

- (NSArray *)profileSetArr {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i< 7; i++) {
        NSString *selectorStr = [NSString stringWithFormat:@"profileSet_%d",i];
        [arr addObject:selectorStr];
    }
    return arr.copy;
}

- (NSArray *)profileSetOnceArr {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i< 7; i++) {
        NSString *selectorStr = [NSString stringWithFormat:@"profileSetOnce_%d",i];
        [arr addObject:selectorStr];
    }
    return arr.copy;
}

- (NSArray *)profileIncrementArr {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i< 7; i++) {
        NSString *selectorStr = [NSString stringWithFormat:@"profileIncrement_%d",i];
        [arr addObject:selectorStr];
    }
    return arr.copy;
}

- (NSArray *)profileAppendArr {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i< 7; i++) {
        NSString *selectorStr = [NSString stringWithFormat:@"profileAppend_%d",i];
        [arr addObject:selectorStr];
    }
    return arr.copy;
}

- (NSArray *)trackArr {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:9];
    for (int i = 0; i< 9; i++) {
        NSString *selectorStr = [NSString stringWithFormat:@"track_%d",i];
        [arr addObject:selectorStr];
    }
    return arr.copy;
}

- (NSArray *)pageViewArr {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:8];
    for (int i = 0; i< 8; i++) {
        NSString *selectorStr = [NSString stringWithFormat:@"pageView_%d",i];
        [arr addObject:selectorStr];
    }
    return arr.copy;
}

- (NSArray *)titleArr {
    return @[@"track",@"pageView",@"alias",@"superProerty",@"profileSet",@"profileSetOnce",@"profileIncrement",@"profileAppend"];
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdenfity = @"ANSDemoTableViewCell";
    ANSDemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfity];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ANSDemoTableViewCell" owner:self options:nil] lastObject];
    }
    cell.titleLabel.text = self.dataSource[indexPath.section][indexPath.row];
    [cell.detailBtn setTitle:[NSString stringWithFormat:@"%d-%d", indexPath.section,indexPath.row] forState:UIControlStateNormal];
//
//    static NSString *cellIdentify = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentify];
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame =CGRectMake(100, 5, 100, 40);
//        [btn setTitle:@"测试" forState:UIControlStateNormal];
//        [btn setBackgroundColor:[UIColor greenColor]];
//        [cell addSubview:btn];
//    }
//    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"detail - %ld", indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selStr = self.dataSource[indexPath.section][indexPath.row];
    [UnitTestCase performSelector:NSSelectorFromString(selStr)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 50)];
    sectionHeaderView.backgroundColor = [UIColor greenColor];
    UILabel *subView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, sectionHeaderView.frame.size.height)];
    subView.textAlignment = NSTextAlignmentCenter;
    subView.text = self.titleArr[section];
    [sectionHeaderView addSubview:subView];
    
    return sectionHeaderView;
}


@end
