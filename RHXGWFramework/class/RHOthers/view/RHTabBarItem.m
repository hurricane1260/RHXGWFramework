//
//  RHTabBarItem.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/1/3.
//
//

#import "RHTabBarItem.h"

@interface RHTabBarItem ()

kRhPStrong UIImageView * itemImgView;

kRhPStrong UILabel * itemLabel;

kRhPStrong UIColor * norColor;

kRhPStrong UIColor * selectedColor;
@end

@implementation RHTabBarItem

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

+ (RHTabBarItem *)buildTabBarItemWithTitle:(NSString *)title withNorColor:(UIColor *)norColor withSelectedColor:(UIColor *)selectedColor withNorImg:(UIImage *)norImg withSelectedImg:(UIImage *)selectedImg{
    RHTabBarItem * item = [[RHTabBarItem alloc] init];
    item.title = title;
    item.norColor = norColor;
    item.selectedColor = selectedColor;
    item.norImg = norImg;
    item.selectedImg = selectedImg;
    
    item.itemLabel.text = title;
    item.itemImgView.image = norImg;
    item.itemLabel.textColor = norColor;
    return item;
}

- (void)initSubviews{
    self.itemImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_optional-stock_nav_nor"]];
//    self.itemImgView = [[UIImageView alloc] initWithImage:self.norImg];

    [self addSubview:self.itemImgView];
    
    self.itemLabel = [UILabel didBuildLabelWithText:self.title font:font0_common_xgw textColor:self.norColor wordWrap:NO];
    [self addSubview:self.itemLabel];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.itemImgView.frame = CGRectMake((self.width - self.itemImgView.width)/2.0f, 5.0f, self.itemImgView.width, self.itemImgView.height);
    [self.itemLabel sizeToFit];
    self.itemLabel.frame = CGRectMake((self.width - self.itemLabel.width)/2.0f, CGRectGetMaxY(self.itemImgView.frame) + 2.0f, self.itemLabel.width, self.itemLabel.height);

}

@synthesize selected = _selected;
- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if (selected) {
        [self.itemImgView setImage:self.selectedImg];
        [self.itemLabel setTextColor:self.selectedColor];
    }
    else{
        [self.itemImgView setImage:self.norImg];
        [self.itemLabel setTextColor:self.norColor];
    }
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title{
    self.itemLabel.text = title;
    [self setNeedsLayout];
}


@end
