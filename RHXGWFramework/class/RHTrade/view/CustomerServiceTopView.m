//
//  CustomerServiceTopView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/4/26.
//
//

#import "CustomerServiceTopView.h"
#import "CustomENView.h"
@interface CustomerServiceTopView ()
@property (nonatomic,strong) CustomENView * EView;
@property (nonatomic,strong) CustomENView * NView;
@end


@implementation CustomerServiceTopView
-(instancetype)init{
    if (self = [super init]) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    self.EView = [[CustomENView alloc]initWithImageName:@"icon_eagle" name:@"智能机器人小E" workHours:@"(24小时)"];
    self.EView.tag = 20;
    UITapGestureRecognizer * Etap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ENTap:)];
    [self.EView addGestureRecognizer:Etap];
    [self addSubview:self.EView];

    self.NView = [[CustomENView alloc]initWithImageName:@"icon_niudafa" name:@"在线客服牛大发" workHours:@"(工作日: 9:00-17:00)"];
    self.NView.tag = 21;
    UITapGestureRecognizer * Ntap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ENTap:)];
    [self.NView addGestureRecognizer:Ntap];
    [self addSubview:self.NView];
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews ];
    CGFloat height = 372/3;
    self.EView.frame = CGRectMake(0, 0, self.width/2, height);
    self.NView.frame = CGRectMake(self.width/2, 0, self.width/2, height);
    
}
-(void)ENTap:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag;
    
    switch (tag) {
        case 20:
            if (self.tapBlock) {
                self.tapBlock(@"",EType);
            }
            
            break;
        case 21:
            if (self.tapBlock) {
                self.tapBlock(@"",NType);
            }
            
            break;
        
        default:
            break;
    }
    
}
@end
