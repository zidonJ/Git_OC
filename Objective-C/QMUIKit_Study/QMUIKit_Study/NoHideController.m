//
//  NoHideController.m
//  QMUIKit_Study
//
//  Created by zidonj on 2019/11/25.
//  Copyright © 2019 zidonj. All rights reserved.
//

#import "NoHideController.h"

@interface NoHideController ()

@end

@implementation NoHideController

#pragma mark -- cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
}

//MARK:  -- UIConfig

- (void)uiConfig {

    [self layoutContrains];
}

//MARK:  -- Public Method

//MARK:  -- Private Method

//MARK:  - Action


//MARK:  - KVO

//MARK:  - noticfication

//MARK:  -- Protocols 三方｜自定义 代理｜协议

//MARK:  -- UITableViewDelegate

//MARK:  -- UITableViewDataSource

//MARK:  -- http request

//MARK:  -- layoutContrains masonry布局代码
- (void)layoutContrains {
    
    
}

//MARK:  -- Setters

//MARK:  -- Getters


- (void)dealloc {
    NSLog(@"%@-释放",[self class]);
}



@end
