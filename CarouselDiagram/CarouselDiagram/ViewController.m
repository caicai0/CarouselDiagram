//
//  ViewController.m
//  CarouselDiagram
//
//  Created by liyufeng on 14/12/15.
//  Copyright (c) 2014年 liyufeng. All rights reserved.
//

#import "ViewController.h"
#import "CarouseCollectionViewCell.h"
#import "CarouselDiagramView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CarouselDiagramView * view = [[CarouselDiagramView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    view.cellClass = [CarouseCollectionViewCell class];
    view.datas = @[@"1",@"2",@"3"];
    
    // Do any additional setup after loading the view, typically from a nib.
}

@end
