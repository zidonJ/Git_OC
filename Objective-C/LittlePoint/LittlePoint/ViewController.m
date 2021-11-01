//
//  ViewController.m
//  LittlePoint
//
//  Created by jiangzedong on 2021/10/29.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _v = [[WBLittlePointView alloc] initWithFrame:CGRectMake(10, 100, 20, 200)];
    [self.view addSubview:_v];
    
    [_v reloadUIWithCount:7 selectIndex:3];
    __weak typeof(self) weakSelf = self;
    _v.reChangeContentHeight = ^(CGFloat needHeight) {
        weakSelf.v.height = needHeight;
    };
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 1)];
    v1.backgroundColor = UIColor.redColor;
    [self.view addSubview:v1];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    if (point.y < 400) {
        [self up];
    } else {
        [self down];
    }
    
    NSLog(@"余数:%d-%d",7%6,3%6);
}

- (IBAction)sendertestResetWith4
{
    [self.v reloadUIWithCount:4 selectIndex:2];
}

- (IBAction)testResetWith5
{
    [self.v reloadUIWithCount:5 selectIndex:0];
}

- (IBAction)testResetWith6
{
    [self.v reloadUIWithCount:6 selectIndex:4];
}

- (IBAction)testResetWith7
{
    [self.v reloadUIWithCount:7 selectIndex:1];
}

- (IBAction)testResetWith10
{
    [self.v reloadUIWithCount:10 selectIndex:8];
}

- (IBAction)testResetWith20
{
    [self.v reloadUIWithCount:20 selectIndex:11];
}

- (void)up
{
    NSLog(@"up");
    [_v scrollToTop];
}

- (void)down
{
    NSLog(@"down");
    [_v scrollToDown];
}


@end
