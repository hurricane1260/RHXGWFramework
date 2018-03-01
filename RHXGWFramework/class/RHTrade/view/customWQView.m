//
//  customWQView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/5/3.
//
//

#import "customWQView.h"

@interface customWQView ()
@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)UILabel * titleLb;
@property (nonatomic,copy)NSString * logoImage;
@property (nonatomic,copy)NSString * title;
@end

@implementation customWQView

-(instancetype)initWithImage:(NSString *)image title:(NSString *)title{
    
    if (self = [super init]) {
        [self initSubViews];
        _logoImage = image;
        _title = title;
        
    }
    return self;
}
-(void)initSubViews{
    self.imageView = [[UIImageView alloc]init];
    [self addSubview:self.imageView];
    
    
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.textColor = color3_text_xgw;
    self.titleLb.font = font3_common_xgw;
    [self addSubview:self.titleLb];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    UIImage * image = [UIImage imageNamed:self.logoImage];
    self.imageView.frame = CGRectMake(0, (self.frame.size.height -image.size.height)/2, image.size.width, image.size.height);
    
    [self.titleLb sizeToFit];
    self.titleLb.center = CGPointMake(CGRectGetMaxX(self.imageView.frame)+5+self.titleLb.size.width/2
                                      ,self.frame.size.height/2);
    
    self.imageView.image = image;
    self.titleLb.text = self.title;
    
}
-(CGSize)getSelfSize{
    
    UIImage * image = [UIImage imageNamed:self.logoImage];
    [self.titleLb sizeToFit];
    CGSize size = CGSizeMake(image.size.width+3+self.titleLb.size.width, image.size.height);
    
    return size;
}
@end
