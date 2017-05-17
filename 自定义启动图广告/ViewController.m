//
//  ViewController.m
//  自定义启动图广告
//
//  Created by haozp on 2017/5/17.
//  Copyright © 2017年 haozp. All rights reserved.
//

#import "ViewController.h"
#import "ADViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //跳转广告的通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skipToAD) name:@"skipToAD" object:nil];
}
- (void)skipToAD{
    ADViewController *adVC = [[ADViewController alloc] init];
    [self.navigationController pushViewController:adVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
