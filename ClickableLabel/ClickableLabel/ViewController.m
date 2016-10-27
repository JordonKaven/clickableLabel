//
//  ViewController.m
//  ClickableLabel
//
//  Created by 彭柯柱 on 2016/10/27.
//  Copyright © 2016年 彭柯柱. All rights reserved.
//

#import "UILabel+Clickable.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
  label.userInteractionEnabled = YES;
  label.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:label];
  label.text = @"abcdefghijk17765105041";
  [label addAction:^{
	NSLog(@"label's action been done!");
  } forString:@"17765105041" underLine:YES];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
