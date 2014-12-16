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
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        [arr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    view.datas = arr;
    view.nonDataModel = @"nodataModel";
    view.animationDuration = 0.5;
    [view startAnimation];
    
    // Do any additional setup after loading the view, typically from a nib.
}

@end
