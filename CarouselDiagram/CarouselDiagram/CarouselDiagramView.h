//
//  CarouselDiagramView.h
//  CarouselDiagram
//
//  Created by liyufeng on 14/12/16.
//  Copyright (c) 2014年 liyufeng. All rights reserved.
//

//使用要求 datas 中存储的对象 通过协议 CellModel 设置到 Class<CellModel> 的实例中

#import <UIKit/UIKit.h>
@protocol CellModel<NSObject>
- (void)setModel:(id)model;
@end

@interface CarouselDiagramView : UIView

@property (nonatomic, strong)NSArray * datas;//数据源
@property (nonatomic, assign)NSTimeInterval animationDuration; //默认时间4s 因为与动画有关  时间不能 <=0.3s
@property (nonatomic, assign)Class<CellModel> cellClass;
@property (nonatomic, strong)id nonDataModel;
@property (nonatomic, copy)void(^didSelectedIndex)(NSInteger index);

- (void)startAnimation;//配置好后启动动画;

@end
