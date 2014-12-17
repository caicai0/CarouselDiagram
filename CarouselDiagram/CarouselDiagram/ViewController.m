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
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    [scrollView addSubview:view];
    scrollView.pagingEnabled = YES;
    
    [scrollView setContentSize:CGSizeMake(self.view.bounds.size.width*2, self.view.bounds.size.height)];
    
    view.cellClass = [CarouseCollectionViewCell class];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<2; i++) {
        [arr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    view.datas = arr;
    view.nonDataModel = @"nodataModel";
    view.animationDuration = 1000;
    [view startAnimation];
    
    // Do any additional setup after loading the view, typically from a nib.
}

@end
