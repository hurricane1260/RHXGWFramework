//
//  RevenueView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2018/3/29.
//

#import "RevenueView.h"
#import "RevenueItemView.h"
#import "ForumLayoutManager.h"

#define bottomLbText @"      本人确认上述信息真实,准确和完整,并承诺当上述信息发生变更时,将在30日内通知贵公司,否则本人承担由此造成的不利后果"

@interface RevenueView ()
@property (nonatomic,strong)UIView * lineView;

@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)UILabel* topTitleLb;

/**仅为中国税收居民*/
@property (nonatomic,strong)RevenueItemView * revenueResidentView;
/**仅为非居民*/
@property (nonatomic,strong)RevenueItemView * notResidentView;
/**既是中国税收居民又是其他国家税收居民*/
@property (nonatomic,strong)RevenueItemView * otherResidentView;



@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UILabel * bottomLb;
@property (nonatomic,strong)UIButton * selectBtn;

@property (nonatomic,strong)UIView * bottomLineView;


@end


@implementation RevenueView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
        self.isSelectBtn = YES;
    }
    return self;
}
-(void)initSubViews{
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = color16_other_xgw;
    [self addSubview:self.lineView];
    
    self.topView = [[UIView alloc]init];
    self.topView.backgroundColor = color1_text_xgw;
    [self addSubview:self.topView];
    
    self.topTitleLb = [UILabel didBuildLabelWithText:@"本人声明为:" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.topView addSubview:self.topTitleLb];
    
    [self.topView addAutoLineWithColor:color16_other_xgw];
    
    
    
    self.revenueResidentView = [[RevenueItemView alloc]initWithTitle:@"仅为中国税收居民" andImage:img_open_circleClick];
    self.revenueResidentView.tag = 1;
    [self addSubview:self.revenueResidentView];
    UITapGestureRecognizer *revenueResidentViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(revenueTap:)];
    [self.revenueResidentView addGestureRecognizer:revenueResidentViewTap];
    
    
    
    
    self.notResidentView =[[RevenueItemView alloc]initWithTitle:@"仅为非居民" andImage:img_open_circleNoClick];
    self.notResidentView.tag = 2;
    [self addSubview:self.notResidentView];
    UITapGestureRecognizer *notResidentViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(revenueTap:)];
    [self.notResidentView addGestureRecognizer:notResidentViewTap];
    
    
    
    self.otherResidentView =[[RevenueItemView alloc]initWithTitle:@"既是中国税收居民又是其他国家(地区)税收居民" andImage:img_open_circleNoClick];
    self.otherResidentView.tag = 3;
    [self addSubview:self.otherResidentView];
    UITapGestureRecognizer *otherResidentViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(revenueTap:)];
    [self.otherResidentView addGestureRecognizer:otherResidentViewTap];
    
    
    self.bottomView = [[UIView alloc]init];
    [self addSubview:self.bottomView];
    self.bottomView.backgroundColor = color1_text_xgw;
    
    self.bottomLb = [UILabel didBulidLabelWithText:bottomLbText font:font2_common_xgw textColor:color4_text_xgw Spacing:5.0];
    [self.bottomView addSubview:self.bottomLb];
    
    self.selectBtn = [[UIButton alloc]init];
    [self.bottomView addSubview:self.selectBtn];
    [self.selectBtn setImage:img_open_deselect forState:UIControlStateNormal];
    [self.selectBtn setImage:img_open_click forState:UIControlStateSelected];
    self.selectBtn.selected = YES;
    [self.selectBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomLineView = [[UIView  alloc]init];
    self.bottomLineView.backgroundColor = color16_other_xgw;
    [self.bottomView addSubview:self.bottomLineView];

    
    
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.lineView.frame = CGRectMake(0, 0, self.width, 8);
    self.topView.frame = CGRectMake(0,CGRectGetMaxY(self.lineView.frame), self.width, 40);
    
    [self.topTitleLb sizeToFit];
    self.topTitleLb.origin = CGPointMake(24, (self.topView.height-self.topTitleLb.height)/2);
    
    self.topView.autoLine.frame = CGRectMake(0, self.topView.height-0.5, self.topView.width, 0.5);
    
    self.revenueResidentView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.width, 50);
    
    self.notResidentView.frame = CGRectMake(0, CGRectGetMaxY(self.revenueResidentView.frame), self.width, 50);
    
    self.otherResidentView.frame = CGRectMake(0, CGRectGetMaxY(self.notResidentView.frame), self.width, 50);
    
    
    self.bottomLineView.frame = CGRectMake(0, CGRectGetMaxY(self.otherResidentView.frame), self.width, 8);
    
    
    CGSize bottomLbSize = [ForumLayoutManager autoSizeWidthOrHeight:MAXFLOAT width:self.width-48 font:font2_common_xgw content:self.bottomLb.text space:5.0];
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.bottomLb.text];
    
//    // 2.添加表情图片
//    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//    // 表情图片
//    UIImage * image = [UIImage imageNamed:@"icon_click"];
//    attch.image = image;
//    // 设置图片大小
//    attch.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
//
//    // 创建带有图片的富文本
//    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
//    [attributedString insertAttributedString:string atIndex:0];// 插入某个位置
//
//    // 用label的attributedText属性来使用富文本
//    self.bottomLb.attributedText = attributedString;

    self.bottomLb.frame = CGRectMake(24, 12, bottomLbSize.width, bottomLbSize.height);
    
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.otherResidentView.frame), self.width, CGRectGetMaxY(self.bottomLb.frame)+20);
    UIImage * selectBtnImage  = img_open_click;
    self.selectBtn.frame = CGRectMake(24, 12, selectBtnImage.size.width, selectBtnImage.size.height);
    
     self.bottomLineView.frame = CGRectMake(0,self.bottomView.height-8, self.width, 8);
    
    if (self.heightBlock) {
        self.heightBlock(CGRectGetMaxY(self.bottomView.frame));
    }
    
}
-(void)clickBtn:(UIButton *)btn{
    
    self.selectBtn.selected = !self.selectBtn.selected;
    if (self.selectBtn.selected) {
        self.isSelectBtn = YES;
    }else{
        self.isSelectBtn = NO;
    }
    
    if (self.btnBlock) {
        self.btnBlock();
    }
    
}
-(void)revenueTap:(UITapGestureRecognizer *)tap{
    if (!self.itemBlock) {
        return;
    }
    
    switch (tap.view.tag) {
        case 1:
            self.itemBlock(Resident);
            break;
            
        case 2:
            self.itemBlock(notResident);
            break;
            
        case 3:
            self.itemBlock(otherResident);
            break;
            
        default:
            break;
    }
}


@end
