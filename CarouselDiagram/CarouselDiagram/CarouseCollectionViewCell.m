//
//  CarouseCollectionViewCell.m
//  CarouselDiagram
//
//  Created by liyufeng on 14/12/15.
//  Copyright (c) 2014年 liyufeng. All rights reserved.
//

#import "CarouseCollectionViewCell.h"

@interface CarouseCollectionViewCell ()
@property (nonatomic, strong)UILabel * titleLabel;
@end

@implementation CarouseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.frame = CGRectMake(0, 0, 100, 50);
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    if ([title isKindOfClass:[NSString class]]) {
        _title = title;
    }
    [self updateInfo];
}

- (void)updateInfo{
    self.titleLabel.text = self.title;
}

@end
