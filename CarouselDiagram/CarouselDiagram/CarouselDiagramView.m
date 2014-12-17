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
        [self updateTimer];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = self.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        
        [self addSubview:self.collectionView];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    return self;
}
//public

- (void)startAnimation{
    if (_datas.count>1) {
        [self.timer resumeTimerAfterTimeInterval:self.animationDuration];
    }else{
        [self.timer pauseTimer];
    }
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

- (void)setNonDataModel:(id)nonDataModel{
    if (nonDataModel) {
        _nonDataModel = nonDataModel;
        [self updateResource];
        [self reloadData];
    }
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration{
    if (animationDuration >= 0 && _animationDuration != animationDuration) {
        _animationDuration = animationDuration;
        [self updateTimer];
    }
}

#pragma mark - private

- (void)updateTimer{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(carouselAnimartion:) userInfo:nil repeats:YES];
    [self.timer pauseTimer];
}

- (void)reloadData{
    if (_cellClass && _datas && [_datas isKindOfClass:[NSArray class]] && _datas.count) {
        [self.collectionView reloadData];
        if (_datas.count>1) {
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width, 0)];
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
        if (_nonDataModel) {
            [self.resourceArray addObject:self.nonDataModel];
        }
    }
}

- (void)carouselAnimartion:(NSTimer *)timer{
    int contentOffsetX = (int)self.collectionView.contentOffset.x;
    NSInteger index = contentOffsetX/(int)self.collectionView.bounds.size.width;
    if(index>=self.resourceArray.count-1){//动画时间<=0.3 时 的bug 处理
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }else{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

#pragma mark - UICollectionViewDelegate

//UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_datas.count>1){
       [self.timer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x>scrollView.bounds.size.width * (self.datas.count+1)) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }else if(scrollView.contentOffset.x<=0){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.datas.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //旋转 方向时 不调用
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
        if (indexPath.item%2) {
            cell.backgroundColor = [UIColor redColor];
        }else{
            cell.backgroundColor = [UIColor blueColor];
        }
        [cell setModel:self.resourceArray[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.didSelectedIndex){
        NSInteger index = indexPath.item -1;
        if (index == -1) {
            index = _datas.count-1;
        }else if(index == _datas.count){
            index = 0;
        }
        self.didSelectedIndex(index);
    }
}

- (void)dealloc{
    if (_timer) {
        [_timer invalidate];
    }
}

@end
