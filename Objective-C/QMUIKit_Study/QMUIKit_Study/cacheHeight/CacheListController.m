//
//  CacheListController.m
//  QMUIKit_Study
//
//  Created by zidonj on 2019/12/16.
//  Copyright © 2019 zidonj. All rights reserved.
//

#import "CacheListController.h"
#import "CacheItem.h"
#import "CacheCell1.h"
#import "CacheCell2.h"
#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>

static NSString *url1 = @"https://gss2.bdstatic.com/9fo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=a3f9560145c2d562e605d8bf8678fb8a/72f082025aafa40f513a36bca164034f79f019d6.jpg";
static NSString *url2 = @"https://up.enterdesk.com/edpic/9c/97/fe/9c97fe76cdc5d6f352c433a51c4857a4.jpg";

@interface CacheListController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray<CacheItem *> *dataSource;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation CacheListController

#pragma mark -- cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
    [self prepareDataSource];
    [self.tableView reloadData];
}

//MARK:  -- UIConfig

- (void)uiConfig {

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self layoutContrains];
}

//MARK:  -- Public Method

//MARK:  -- Private Method

//MARK:  - Action


//MARK:  - KVO

//MARK:  - noticfication

//MARK:  -- Protocols 三方｜自定义 代理｜协议

//MARK:  -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CacheItem *item = self.dataSource[indexPath.row];
    return [tableView qmui_heightForCellWithIdentifier:NSStringFromClass(item.cellClass) configuration:^(__kindof UITableViewCell *cell) {
        [cell performSelector:@selector(setContent:) withObject:item];
    }];
}

//MARK:  -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CacheItem *item = self.dataSource[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(item.cellClass)
                                                            forIndexPath:indexPath];
    
    [cell performSelector:@selector(setContent:) withObject:item];
    return cell;
}

//MARK:  -- http request

//MARK:  -- layoutContrains masonry布局代码
- (void)layoutContrains {
    
    
}

//MARK:  -- Setters

//MARK:  -- Getters

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 376.0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.1)];
        _tableView.tableFooterView = [UIView new];
        
        UINib *nib = [UINib nibWithNibName:@"CacheCell1" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"CacheCell1"];
        
        UINib *nib1 = [UINib nibWithNibName:@"CacheCell2" bundle:nil];
        [_tableView registerNib:nib1 forCellReuseIdentifier:@"CacheCell2"];
    }
    return _tableView;
}

- (void)prepareDataSource {
    
    CacheItem *item = [[CacheItem alloc] init];
    item.imgUrl1 = url1;
    item.text = @"阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了";
    item.cellClass = CacheCell1.class;
    [self.dataSource addObject:item];
    
    item = [[CacheItem alloc] init];
    item.imgUrl1 = url1;
    item.text = @"阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了";
    item.cellClass = CacheCell1.class;
    [self.dataSource addObject:item];
    
    item = [[CacheItem alloc] init];
    item.imgUrl1 = url1;
    item.text = @"阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了";
    item.cellClass = CacheCell1.class;
    [self.dataSource addObject:item];
    
    item = [[CacheItem alloc] init];
    item.imgUrl1 = url1;
    item.text = @"阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了";
    item.cellClass = CacheCell1.class;
    [self.dataSource addObject:item];
    
    item = [[CacheItem alloc] init];
    item.imgUrl1 = url1;
    item.text = @"阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了";
    item.cellClass = CacheCell1.class;
    [self.dataSource addObject:item];
    
    item = [[CacheItem alloc] init];
    item.imgUrl1 = url1;
    item.imgUrl2 = url2;
    item.text = @"阿里斯顿放假啊啦舒服了啊师";
    item.cellClass = CacheCell2.class;
    [self.dataSource addObject:item];
    
    item = [[CacheItem alloc] init];
    item.imgUrl1 = url1;
    item.imgUrl2 = url2;
    item.text = @"阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了";
    item.cellClass = CacheCell2.class;
    [self.dataSource addObject:item];
    
    item = [[CacheItem alloc] init];
    item.imgUrl1 = url1;
    item.imgUrl2 = url2;
    item.text = @"阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了";
    item.cellClass = CacheCell2.class;
    [self.dataSource addObject:item];
    
    item = [[CacheItem alloc] init];
    item.imgUrl1 = url1;
    item.imgUrl2 = url2;
    item.text = @"阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了";
    item.cellClass = CacheCell2.class;
    [self.dataSource addObject:item];
    
    item = [[CacheItem alloc] init];
    item.imgUrl1 = url1;
    item.imgUrl2 = url2;
    item.text = @"阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了";
    item.cellClass = CacheCell2.class;
    [self.dataSource addObject:item];
    
    item = [[CacheItem alloc] init];
    item.imgUrl1 = url1;
    item.imgUrl2 = url2;
    item.text = @"阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦";
    item.cellClass = CacheCell2.class;
    [self.dataSource addObject:item];
    
    item = [[CacheItem alloc] init];
    item.imgUrl1 = url1;
    item.imgUrl2 = url2;
    item.text = @"阿里斯顿放假啊啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了啊师傅啊说法发啊师傅啊法律啊啦舒服了艾芙洛拉风啊筏啦啦筏啦筏啦舒服了";
    item.cellClass = CacheCell2.class;
    [self.dataSource addObject:item];
    
}

- (void)dealloc {
    NSLog(@"%@-释放",[self class]);
}



@end
