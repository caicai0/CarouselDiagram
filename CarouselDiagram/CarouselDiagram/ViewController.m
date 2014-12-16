//
//  ViewController.m
//  CarouselDiagram
//
//  Created by liyufeng on 14/12/15.
//  Copyright (c) 2014年 liyufeng. All rights reserved.
//

#import "ViewController.h"
#import "CarouseCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSArray * arr;
@property (nonatomic, strong)NSArray * rarr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arr = @[@(10),@(20),@(30)];
    self.rarr = @[@(30),@(10),@(20),@(30),@(10)];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = self.view.bounds.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.collectionView registerClass:[CarouseCollectionViewCell class] forCellWithReuseIdentifier:@"CarouseCollectionViewCell"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x>scrollView.bounds.size.width * 3) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    }else if(scrollView.contentOffset.x<=0){
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"123");
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.rarr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CarouseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CarouseCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.title = [NSString stringWithFormat:@"%@",self.rarr[indexPath.row]];
    NSLog(@"======= %ld ",(long)indexPath.row);
    return cell;
}

@end
