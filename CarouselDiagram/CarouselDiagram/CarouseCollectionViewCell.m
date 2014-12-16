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
        static int a;
        a++;
        NSLog(@"%d",a);
        self.backgroundColor = [UIColor redColor];
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.frame = CGRectMake(10, 10, 400, 400);
        self.titleLabel.font = [UIFont systemFontOfSize:210];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setModel:(NSString *)model{
    if ([model isKindOfClass:[NSString class]]) {
        _model = model;
    }
    [self updateInfo];
}

- (void)updateInfo{
    self.titleLabel.text = self.model;
}

@end
