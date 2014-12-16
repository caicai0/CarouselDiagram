//
//  CarouselDiagramView.m
//  CarouselDiagram
//
//  Created by liyufeng on 14/12/16.
//  Copyright (c) 2014年 liyufeng. All rights reserved.
//

#import "CarouselDiagramView.h"
#import "NSTimer+Addition.h"

@interface CarouselDiagramView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSMutableArray *resourceArray;
@property (nonatomic, strong)NSTimer * timer;

@end

@implementation CarouselDiagramView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.resourceArray = [NSMutableArray array];
        self.animationDuration = 4;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(carouselAnimartion:) userInfo:nil repeats:YES];
        [self.timer pauseTimer];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = self.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        
        [self addSubview:self.collectionView];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.pagingEnabled = YES;
    }
    return self;
}

//setter

- (void)setDatas:(NSArray *)datas{
    if (datas && [datas isKindOfClass:[NSArray class]]) {
        _datas = datas;
    }else{
        _datas = nil;
    }
    [self updateResource];
    [self reloadData];
}

- (void)setCellClass:(Class<CellModel>)cellClass{
    if (cellClass && cellClass != _cellClass) {
        [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
        _cellClass = cellClass;
    }
    [self reloadData];
}

#pragma mark - private

- (void)reloadData{
    if (_cellClass && _datas && [_datas isKindOfClass:[NSArray class]] && _datas.count) {
        [self.collectionView reloadData];
        if (_datas.count>1) {
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width, 0)];
            //启动定时器
            [self.timer resumeTimerAfterTimeInterval:self.animationDuration];
        }else{
            //不启动定时
            [self.timer pauseTimer];
        }
    }
}

- (void)updateResource{
    [self.resourceArray removeAllObjects];
    
    if (_datas.count) {
        [self.resourceArray addObject:_datas.lastObject];
        [self.resourceArray addObjectsFromArray:_datas];
        [self.resourceArray addObject:_datas.firstObject];
    }else{
        [self.resourceArray addObject:self.nonDataModel];
    }
}

- (void)carouselAnimartion:(NSTimer *)timer{
    NSArray * arr = [self.collectionView visibleCells];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:arr.lastObject];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:indexPath.section] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - UICollectionViewDelegate

//UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.timer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x>scrollView.bounds.size.width * (self.datas.count+1)) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }else if(scrollView.contentOffset.x<=0){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.datas.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x>=scrollView.bounds.size.width * (self.datas.count+1)) {
        [self.collectionView setContentOffset:CGPointMake(scrollView.bounds.size.width * (1), scrollView.contentOffset.y)];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.resourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell<CellModel> * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(_cellClass) forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(setModel:)]) {
        [cell setModel:self.resourceArray[indexPath.row]];
    }
    return cell;
}

@end
